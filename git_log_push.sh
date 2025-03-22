#!/bin/bash

REPO_DIR="$(pwd)"
LOG_DIR="$REPO_DIR/system_monitor_log"

cd "$REPO_DIR"

git add .
git commit -m "Add system monitoring logs"
git push origin main 
