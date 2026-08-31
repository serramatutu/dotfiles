#!/usr/bin/env python3
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import time
from collections import Counter

MAX_FILES = 200
CACHE_TTL = 7 * 86400

LANGS = {
    "bash": (".sh", ["comment"]),
    "c": (".c", ["comment"]),
    "cpp": (".cpp", ["comment"]),
    "csharp": (".cs", ["comment"]),
    "css": (".css", ["comment"]),
    "dart": (".dart", ["comment", "block_comment"]),
    "elixir": (".ex", ["comment"]),
    "go": (".go", ["comment"]),
    "haskell": (".hs", ["comment"]),
    "html": (".html", ["comment"]),
    "java": (".java", ["line_comment", "block_comment"]),
    "javascript": (".js", ["comment"]),
    "jsx": (".jsx", ["comment"]),
    "kotlin": (".kt", ["line_comment", "multiline_comment"]),
    "lua": (".lua", ["comment"]),
    "php": (".php", ["comment"]),
    "python": (".py", ["comment"]),
    "ruby": (".rb", ["comment"]),
    "rust": (".rs", ["line_comment", "block_comment"]),
    "scala": (".scala", ["comment", "block_comment"]),
    "solidity": (".sol", ["comment"]),
    "swift": (".swift", ["comment", "multiline_comment"]),
    "tsx": (".tsx", ["comment"]),
    "typescript": (".ts", ["comment"]),
    "yaml": (".yaml", ["comment"]),
}

EXTS = {
    ".bash": "bash", ".sh": "bash", ".zsh": "bash",
    ".c": "c", ".h": "c",
    ".cc": "cpp", ".cpp": "cpp", ".cxx": "cpp", ".hh": "cpp", ".hpp": "cpp",
    ".cs": "csharp",
    ".css": "css",
    ".dart": "dart",
    ".ex": "elixir", ".exs": "elixir",
    ".go": "go",
    ".hs": "haskell",
    ".htm": "html", ".html": "html",
    ".java": "java",
    ".cjs": "javascript", ".js": "javascript", ".mjs": "javascript",
    ".jsx": "jsx",
    ".kt": "kotlin", ".kts": "kotlin",
    ".lua": "lua",
    ".php": "php",
    ".py": "python", ".pyi": "python",
    ".rb": "ruby",
    ".rs": "rust",
    ".scala": "scala", ".sc": "scala",
    ".sol": "solidity",
    ".swift": "swift",
    ".ts": "typescript", ".mts": "typescript", ".cts": "typescript",
    ".tsx": "tsx",
    ".yaml": "yaml", ".yml": "yaml",
}

ALLOW = re.compile(
    r"""
      ^\#!
    | \btype:\s*ignore
    | \bnoqa\b
    | \bpragma\b
    | \b(pylint|ruff|mypy|flake8|isort|pyright|bandit|coverage):
    | \bfmt:\s*(on|off)
    | \beslint(-disable|-enable)?\b
    | \@ts-(ignore|expect-error|nocheck)
    | \b(prettier|biome|istanbul|c8|v8|deepsource|sonar)[-\s]ignore
    | ^//\s*go:
    | \bnolint\b
    | \+build\b
    | -\*-\s*coding
    | \bvim:\s
    | \bshellcheck\s+disable
    | \@generated\b
    | \bcode\s+generated\s+by\b
    | \bDO\s+NOT\s+EDIT\b
    | \b(swiftlint|clang-format|rustfmt|gofmt):
    | \bsafety:\s
    | ^\S*\s*\#?(end)?region\b
    | \byaml-language-server:
    | \byamllint\s+disable
    """,
    re.IGNORECASE | re.VERBOSE,
)

ALLOW_HINT = (
    "If the user explicitly asked for these comments, do not retry — tell them "
    "to re-run with CLAUDE_ALLOW_COMMENTS=1 set, or to disable the hook."
)


def bail():
    sys.exit(0)


def lang_for(path):
    return EXTS.get(os.path.splitext(path)[1].lower())


def ast_grep(lang, kinds, paths):
    rule = json.dumps(
        {
            "id": "nc",
            "language": lang,
            "rule": {"any": [{"kind": k} for k in kinds]},
        }
    )
    try:
        out = subprocess.run(
            [
                "ast-grep", "scan",
                "--inline-rules", rule,
                "--json=compact",
                "--no-ignore", "vcs",
                "--no-ignore", "dot",
                "--no-ignore", "hidden",
                "--no-ignore", "parent",
                "--no-ignore", "global",
                "--no-ignore", "exclude",
            ]
            + list(paths),
            capture_output=True,
            text=True,
            timeout=60,
        )
    except (OSError, subprocess.SubprocessError):
        raise RuntimeError("ast-grep failed")
    if out.returncode not in (0, 1):
        raise RuntimeError(out.stderr.strip() or "ast-grep error")
    if not out.stdout.strip():
        return []
    return json.loads(out.stdout)


def hit(match):
    return (match["range"]["start"]["line"] + 1, match["text"].strip())


def comments(text, lang, ext, kinds):
    if not text.strip():
        return []
    with tempfile.TemporaryDirectory() as d:
        path = os.path.join(d, "scan" + ext)
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(text)
        matches = ast_grep(lang, kinds, [path])
    return sorted(hit(m) for m in matches)


def scan_files(paths):
    groups = {}
    for path in paths:
        lang = lang_for(path)
        if lang is not None:
            groups.setdefault(lang, []).append(path)
    found = {}
    for lang, group in groups.items():
        _, kinds = LANGS[lang]
        try:
            matches = ast_grep(lang, kinds, group)
        except RuntimeError:
            continue
        hits = {p: [] for p in group}
        for m in matches:
            key = os.path.abspath(m.get("file") or "")
            if key in hits:
                hits[key].append(hit(m))
        for path, items in hits.items():
            found[path] = sorted(items)
    return found


def read(path):
    try:
        with open(path, encoding="utf-8") as fh:
            return fh.read()
    except (OSError, UnicodeDecodeError):
        return None


def notebook_cell(path, cell_id):
    nb = read(path)
    if nb is None:
        bail()
    try:
        cells = json.loads(nb)["cells"]
    except (ValueError, KeyError, TypeError):
        bail()
    for cell in cells:
        if cell.get("id") == cell_id:
            if cell.get("cell_type") != "code":
                bail()
            src = cell.get("source", "")
            return src if isinstance(src, str) else "".join(src)
    return ""


def new_comments(old, after):
    before = Counter(t for _, t in old)
    added = []
    for line, text in after:
        if before[text] > 0:
            before[text] -= 1
            continue
        if ALLOW.search(text):
            continue
        added.append((line, text))
    return added


def listing(items):
    out = "\n".join(
        "  line {}: {}".format(line, text if len(text) <= 120 else text[:117] + "...")
        for line, text in items[:20]
    )
    if len(items) > 20:
        out += "\n  ... and {} more".format(len(items) - 20)
    return out


def check_edit(payload):
    tool = payload.get("tool_name")
    ti = payload.get("tool_input") or {}

    if tool == "NotebookEdit":
        path = ti.get("notebook_path") or ""
        lang = "python"
        new = ti.get("new_source")
        if new is None:
            bail()
        mode = ti.get("edit_mode") or "replace"
        old = "" if mode == "insert" else notebook_cell(path, ti.get("cell_id"))
        if mode == "delete":
            bail()
    else:
        path = ti.get("file_path") or ""
        lang = lang_for(path)
        if lang is None:
            bail()
        if tool == "Write":
            new = ti.get("content")
            if new is None:
                bail()
            old = read(path) or ""
        elif tool == "Edit":
            old = read(path)
            if old is None:
                bail()
            find = ti.get("old_string")
            repl = ti.get("new_string")
            if find is None or repl is None or find not in old:
                bail()
            new = old.replace(find, repl) if ti.get("replace_all") else old.replace(find, repl, 1)
        else:
            bail()

    ext, kinds = LANGS[lang]
    try:
        added = new_comments(
            comments(old, lang, ext, kinds), comments(new, lang, ext, kinds)
        )
    except RuntimeError:
        bail()
    if not added:
        bail()

    reason = (
        "Blocked by the no-comments hook: this edit to {} adds {} new comment(s).\n"
        "{}\n"
        "Your instructions say not to add comments to code. Resubmit the edit with "
        "the comments removed; keep the code itself unchanged otherwise.\n"
        "{}"
    ).format(path or "this file", len(added), listing(added), ALLOW_HINT)

    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": reason,
                }
            }
        )
    )
    sys.exit(0)


def git(root, *args):
    try:
        out = subprocess.run(
            ("git", "-C", root) + args,
            capture_output=True,
            text=True,
            timeout=20,
        )
    except (OSError, subprocess.SubprocessError):
        return None
    if out.returncode != 0:
        return None
    return out.stdout


def repo_root(cwd):
    out = git(cwd, "rev-parse", "--show-toplevel")
    if not out or not out.strip():
        return None
    return out.strip()


def dirty_files(root):
    out = git(root, "status", "--porcelain", "-z", "--untracked-files=all")
    if out is None:
        return []
    recs = [r for r in out.split("\0") if r]
    paths = []
    i = 0
    while i < len(recs):
        rec = recs[i]
        i += 1
        if len(rec) < 4:
            continue
        code, rel = rec[:2], rec[3:]
        if code[0] in "RC":
            i += 1
        if "D" in code:
            continue
        paths.append(os.path.join(root, rel))
    return paths


def stamp(path):
    try:
        st = os.stat(path)
    except OSError:
        return None
    return [st.st_mtime_ns, st.st_size]


def cache_dir():
    d = os.path.join(tempfile.gettempdir(), "claude-no-comments")
    try:
        os.makedirs(d, exist_ok=True)
    except OSError:
        return None
    return d


def cache_file(session):
    d = cache_dir()
    if d is None:
        return None
    safe = "".join(c for c in session if c.isalnum() or c in "-_") or "default"
    return os.path.join(d, safe + ".json")


def prune_caches():
    d = cache_dir()
    if d is None:
        return
    cutoff = time.time() - CACHE_TTL
    try:
        names = os.listdir(d)
    except OSError:
        return
    for name in names:
        path = os.path.join(d, name)
        try:
            if os.path.getmtime(path) < cutoff:
                os.remove(path)
        except OSError:
            pass


def load_cache(path):
    if path is None:
        return None
    try:
        with open(path, encoding="utf-8") as fh:
            data = json.load(fh)
    except (OSError, ValueError):
        return None
    return data if isinstance(data, dict) else None


def save_cache(path, data):
    if path is None:
        return
    try:
        tmp = path + ".tmp"
        with open(tmp, "w", encoding="utf-8") as fh:
            json.dump(data, fh)
        os.replace(tmp, path)
    except OSError:
        pass


def snapshot(paths, old):
    new = {}
    stale = []
    for path in paths[:MAX_FILES]:
        st = stamp(path)
        if st is None:
            continue
        prev = old.get(path) if old else None
        if prev and prev.get("stamp") == st:
            new[path] = prev
            continue
        stale.append((path, st))
    scanned = scan_files([p for p, _ in stale]) if stale else {}
    for path, st in stale:
        found = scanned.get(path)
        if found is None:
            continue
        new[path] = {"stamp": st, "comments": found}
    return new


def pin_flagged(new, old, flagged):
    for path in flagged:
        if old and path in old:
            new[path] = old[path]
        else:
            new.pop(path, None)


def check_worktree(payload, enforce):
    cwd = payload.get("cwd") or os.getcwd()
    cache = cache_file(payload.get("session_id") or "default")

    root = repo_root(cwd)
    if root is None:
        bail()

    old = load_cache(cache)
    new = snapshot(dirty_files(root), old)

    added = {}
    if enforce and old is not None:
        for path, entry in new.items():
            hits = new_comments(
                (old.get(path) or {}).get("comments") or [],
                entry.get("comments") or [],
            )
            if hits:
                added[path] = hits

    pin_flagged(new, old, added)
    save_cache(cache, new)

    if not added:
        bail()

    total = sum(len(v) for v in added.values())
    blocks = [
        "{}\n{}".format(os.path.relpath(path, root), listing(items))
        for path, items in sorted(added.items())
    ]
    sys.stderr.write(
        (
            "Blocked by the no-comments hook: a Bash command added {} new "
            "comment(s) to the working tree.\n"
            "{}\n"
            "Your instructions say not to add comments to code. Remove them, and "
            "use Edit/Write rather than Bash to modify source files.\n"
            "{}\n"
        ).format(total, "\n".join(blocks), ALLOW_HINT)
    )
    sys.exit(2)


def main():
    if os.environ.get("CLAUDE_ALLOW_COMMENTS"):
        bail()
    if not shutil.which("ast-grep"):
        bail()
    try:
        payload = json.load(sys.stdin)
    except ValueError:
        bail()

    event = payload.get("hook_event_name") or ""
    if event in ("PostToolUse", "SessionStart"):
        if not shutil.which("git"):
            bail()
        if event == "SessionStart":
            prune_caches()
        enforce = event == "PostToolUse" and payload.get("tool_name") == "Bash"
        check_worktree(payload, enforce)
    elif event == "PreToolUse" or not event:
        check_edit(payload)
    bail()


if __name__ == "__main__":
    try:
        main()
    except SystemExit:
        raise
    except Exception:
        sys.exit(0)
