import os
import sys
import logging
import pathlib
import importlib

import coloredlogs

logging.basicConfig()
coloredlogs.install(
    fmt='%(levelname)-7s %(message)s',
    level='DEBUG'
)
logger = logging.getLogger("installer")

HOME_DIR = str(pathlib.Path.home())
DOTFILES_DIR = sys.argv[1] if 1 < len(sys.argv) else None
ENV = sys.argv[2]

_cwd = DOTFILES_DIR
class _InstallContext:
    @property
    def cwd(self):
        return _cwd
CONTEXT = _InstallContext()

def _pre_install():
    logger.info("Found HOME dir: {0}".format(HOME_DIR))

    sys.path.append(DOTFILES_DIR)
    os.makedirs(os.path.join(HOME_DIR, '.zsh'), exist_ok=True)

def _install():
    logger.info('Beginning install')

    success = []
    failed = []
    topics_dir = os.path.join(DOTFILES_DIR, 'topics')
    
    logger.info('Determining installation order')
    topics = _install_order(os.listdir(topics_dir))
    logger.info('Installing: {0}'.format(', '.join(topics)))

    for topic in topics:
        try:
            _install_topic(topic)
            success.append(topic)
        except Exception as e:
            logger.error(
                "Failed install for {0}. {1}"
                .format(topic, repr(e))
            )
            failed.append(topic)

    if len(success) > 0:
        logger.info("Installed {0}".format(', '.join(success)))
    if len(failed) > 0:
        logger.warning("Failed install for {0}".format(', '.join(failed)))

    logger.info('Finished install')

def _load_method(topic, method):
    install_module = importlib.import_module('topics.'+topic+'.install')
    if (hasattr(install_module, method) and 
        callable(getattr(install_module, method))):
        return getattr(install_module, method)

    return None

def _call_method_if_exists(topic, method, default=None):
    if not os.path.exists(os.path.join(DOTFILES_DIR, 'topics', topic, 'install.py')):
        return default

    m = _load_method(topic, method)
    if m is None:
        return default

    return m()

def _install_order(topics):
    """Topological sorting of dependencies"""
    graph = dict()
    no_deps = set()
    for topic in topics:
        requires = set(_call_method_if_exists(topic, 'requires', default=[]))
        if len(requires) == 0:
            no_deps.add(topic)

        provides = set(_call_method_if_exists(topic, 'provides', default=[]))
        provides.add(topic)
        
        graph[topic] = {
            "provides": provides,
            "requires": requires
        }

    sorted_topics = []
    while len(no_deps) > 0:
        provider = no_deps.pop()
        sorted_topics.append(provider)
        for topic in graph:
            if len(graph[provider]['provides'] & graph[topic]['requires']) > 0:
                graph[topic]['requires'] -= graph[provider]['provides']
                if len(graph[topic]['requires']) == 0:
                    no_deps.add(topic)
                    
    if sum(len(topic['requires']) > 0 for topic in graph.values()):
        raise ValueError("Cyclic dependency graph. Couldn't determine installation order.")
    else:
        return sorted_topics
    

def _install_topic(topic):
    """Installs a topic"""
    logger.info("Installing topic '{0}'".format(topic))

    topic_path = os.path.join(DOTFILES_DIR, 'topics', topic)
    install_method = None
    zsh_files = []
    symlink_files = []
    for file_name in os.listdir(topic_path):
        file_path = os.path.join(topic_path, file_name)
        base_name, ext = os.path.splitext(file_name)
        
        if ext == '.symlink':
            symlink_files.append(file_path)
        elif ext == '.zsh':
            zsh_files.append(file_path)
        elif file_name != 'install.py':
            logger.debug(
                "{0} will not be symlinked nor loaded into zsh."
                .format(file_name)
            )

    global _cwd
    _cwd = topic_path
    _call_method_if_exists(topic, 'install')
    _cwd = DOTFILES_DIR

    for zsh_file in zsh_files:
        _load_env(zsh_file)
    for symlink_file in symlink_files:
        _symlink_home(symlink_file)
    
    logger.info("'{0}' installed successfully".format(topic))

def _symlink_home(src):
    """Symlinks a file into the user's home directory"""
    base_name, ext = os.path.splitext(src)
    dest = os.path.join(
        HOME_DIR, os.path.basename(os.path.normpath(base_name))
    )
    logger.debug('Symlinking {0} onto {1}'.format(src, dest))
    os.symlink(src, dest)

def _load_env(src):
    """Loads .zsh file contents onto the zsh environment"""
    base_name, ext = os.path.splitext(src)
    dest = os.path.join(
        HOME_DIR, '.zsh', os.path.basename(os.path.normpath(base_name)) + ext
    )
    logger.debug(
        "Loading '{0}' into zsh environment"
        .format(base_name)
    )
    os.symlink(src, dest)