#!/bin/bash

# Function to handle SIGTERM
term_handler() {
  echo "SIGTERM received, shutting down..."
  exit 0
}

# Trap SIGTERM signal
trap 'term_handler' SIGTERM

# Wait indefinitely
while true; do
  sleep 1
done