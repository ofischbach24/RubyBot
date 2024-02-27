#!/bin/bash

while true; do
  controller_event=$(ls /dev/input/ | grep "event.*" | grep -o "event[0-9]*" | head -n 1)
  
  if [ -n "$controller_event" ]; then
    echo "PS4 controller detected on /dev/input/$controller_event"
    ruby app.rb "$controller_event"
    sleep 1  # Adjust sleep time as needed to avoid rapid re-checking
  else
    sleep 1
  fi
done
