#!/bin/bash

# Array of session names and commands
declare -A sessions
num_sessions=$1
map_local_file=$2
session_ids=$(seq 1 $1)

# Kill all the existing sessions
tmux kill-server

for session_id in ${session_ids}; do
  # Create a new tmux session in detached mode
  tmux new-session -d -s "$session_id"

  # Send the command to the tmux session
  if [[ "$session_id" =~ ^[0-9]$ ]]; then
    command="source /yopo-artifact/mitmproxy/venv/bin/activate && mitmproxy --map-local-file "$map_local_file" -p 800"$session_id
  elif [[ "$session_id" =~ ^[0-9][0-9]$ ]]; then
    command="source /yopo-artifact/mitmproxy/venv/bin/activate && mitmproxy --map-local-file "$map_local_file" -p 80"$session_id
  elif [[ "$session_id" =~ ^[0-9][0-9][0-9]$ ]]; then
    command="source /yopo-artifact/mitmproxy/venv/bin/activate && mitmproxy --map-local-file "$map_local_file" -p 8"$session_id
  fi
  echo $command
  tmux send-keys -t "$session_id" "$command" C-m
done

