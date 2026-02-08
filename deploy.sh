#!/bin/bash
set -e

# Detect whether docker-compose or docker compose is available
if command -v docker-compose >/dev/null 2>&1; then
    echo "Using legacy docker-compose..."
    docker-compose -f docker-compose.yml up -d
elif docker compose version >/dev/null 2>&1; then
    echo "Using modern docker compose plugin..."
    docker compose -f docker-compose.yml up -d
else
    echo "ERROR: Neither docker-compose nor docker compose found."
    exit 1
fi

# Use modern Docker Compose plugin
docker compose -f docker-compose.yml up -d
