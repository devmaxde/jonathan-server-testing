#!/bin/bash

# Path to your git project
GIT_DIR="."

# Move to the git directory
cd $GIT_DIR || exit

# Store the last hash
LAST_HASH=$(git rev-parse HEAD)

while true; do
    # Perform a git pull
    git pull
    
    # Get the new hash
    NEW_HASH=$(git rev-parse HEAD)
    
    # Check if the hash has changed
    if [ "$LAST_HASH" != "$NEW_HASH" ]; then
        echo "Changes detected, rebuilding Docker containers..."
        
        # Rebuild and restart the containers
        docker compose build
        docker compose up -d
        
        # Update the last hash
        LAST_HASH=$NEW_HASH
    else
        echo "No changes detected."
    fi

    # Wait for 30 seconds
    sleep 30
done
