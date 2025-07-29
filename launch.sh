#!/bin/bash

run_dev() {
  if [ -z "$TMUX" ]; then
    echo "TODO";
    # TODO: Not inside tmux, create a new session
  else
    # Inside tmux, create new windows or panes
    tmux split-window -v \;\
      resize-pane -y 48 -t 0 \;\
      send-keys 'flutter run --debug --verbose --pid-file=/tmp/sn-dev.pid --flavor dbg' Enter \;\
      split-window -h \;\
      resize-pane -R 32 \;\
      send-keys 'nvm use --lts && npx -y nodemon -e dart -x "cat /tmp/sn-dev.pid | xargs -r kill -USR1"' Enter \;\
      select-pane -t 0 \;
  fi
}

# Entrypoint do script
case "$1" in
dev)
    run_dev
    ;;
*)
    echo "Usage: $0 {dev}"
    exit 1
    ;;
esac
