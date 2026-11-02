#!/bin/bash
# Starts the Planner at http://localhost:8080 (needed for Google Calendar sign-in).
# Keep this window open while you use the planner. Close it to stop.
cd "$(dirname "$0")"
(sleep 1; open "http://localhost:8080/planner.html" 2>/dev/null || xdg-open "http://localhost:8080/planner.html") &
python3 -m http.server 8080 --bind 127.0.0.1
