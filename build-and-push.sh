#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Variables
DOCKER_HUB_USERNAME="henriksin1"
VERSION="latest" 

# Function to build and push Docker images
build-and-push() {
    MODULE_NAME=$1

    echo "====================================="
    echo "Processing module: $MODULE_NAME"
    echo "====================================="

    # Navigate to the module directory
    cd "$MODULE_NAME"

    # Maven build
    echo "Running 'mvn clean install' for $MODULE_NAME..."
    mvn clean install

    # Build and push the Docker image
    IMAGE_NAME="$DOCKER_HUB_USERNAME/$MODULE_NAME:$VERSION"
    echo "Building Docker image: $IMAGE_NAME..."
    docker build -t "$IMAGE_NAME" .

    echo "Pushing Docker image: $IMAGE_NAME..."
    docker push "$IMAGE_NAME"

    # Navigate back to the root directory
    cd ..
}

# Modules to process
MODULES=("productcatalogue" "shopfront" "stockmanager")

# Loop through each module
for MODULE in "${MODULES[@]}"; do
    build-and-push "$MODULE"
done

echo "====================================="
echo "All modules have been processed successfully!"
echo "====================================="
