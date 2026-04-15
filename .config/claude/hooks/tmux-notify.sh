#!/bin/sh

if [ "$(tmux display-message -p "#{pane_id}")" != "$TMUX_PANE" ]; then
  claude_session=$(tmux display-message -p -t "$TMUX_PANE" "#{session_name}")
  tmux display-message "Claude needs attention ($claude_session)"
fi

