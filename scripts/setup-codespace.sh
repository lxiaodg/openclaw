#!/bin/bash
set -e

# Define target directories
CONFIG_DIR="$HOME/.openclaw"
AUTH_DIR="$HOME/.openclaw/agents/main/agent"

# Create directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$AUTH_DIR"

# Check if OPENCLAW_CONFIG_BASE64 secret is present
if [ -n "$OPENCLAW_CONFIG_BASE64" ]; then
    echo "Found OPENCLAW_CONFIG_BASE64, restoring configuration..."
    
    # Create a temporary directory for extraction
    TEMP_DIR=$(mktemp -d)
    
    # Decode and extract
    echo "$OPENCLAW_CONFIG_BASE64" | base64 -d | tar -xz -C "$TEMP_DIR"
    
    # Move files to correct locations
    if [ -f "$TEMP_DIR/openclaw.json" ]; then
        mv "$TEMP_DIR/openclaw.json" "$CONFIG_DIR/"
        echo "Restored openclaw.json"
    fi
    
    if [ -f "$TEMP_DIR/auth-profiles.json" ]; then
        mv "$TEMP_DIR/auth-profiles.json" "$AUTH_DIR/"
        echo "Restored auth-profiles.json"
    fi
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    echo "Configuration restored successfully!"
else
    echo "OPENCLAW_CONFIG_BASE64 not found. Skipping configuration restore."
    echo "Please set this secret in your GitHub repository if you want to sync your local config."
fi
