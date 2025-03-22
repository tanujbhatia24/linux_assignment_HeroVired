#!/bin/bash

REPO_DIR="$(pwd)"
LOG_DIR="$REPO_DIR/system_monitor_log"

cd "$REPO_DIR"

#Run system monitoring script.
./system_monitor.sh

#Push the latest log to github repo.
git add .
git commit -m "Add system monitoring logs"
git push origin main 
