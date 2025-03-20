#!/bin/bash

REPO_DIR="$(pwd)"
LOG_DIR="$REPO_DIR/system_monitor"


cd "$REPO_DIR"
#git add "$LOG_DIR"/*.log

git add .
git commit -m "Add system monitoring logs - $(date +'%Y-%m-%d %H:%M:%S')"
git push origin main 
