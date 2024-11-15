#!/bin/bash

# Variables
DOCKER_IMAGE_NAME="spring-boot-app"
DOCKER_TAG="latest"
GIT_BRANCH=${1:-main}  # Allows specifying a branch as an argument, defaults to 'main'

# Step 0: Pull the latest code from GitHub
echo "Pulling the latest code from GitHub..."
if [ -d .git ]; then
  git reset --hard HEAD
  git pull origin $GIT_BRANCH || {
    echo "Failed to pull from branch '$GIT_BRANCH'. Please check your branch name and try again."
    exit 1
  }
else
  echo "This directory is not a Git repository. Please clone the repository first."
  exit 1
fi

# Step 0.1: Ensure proper permissions for Docker socket
echo "Checking Docker permissions..."
if [ ! -w /var/run/docker.sock ]; then
  echo "Setting permissions for Docker socket..."
  sudo chmod 666 /var/run/docker.sock || {
    echo "Failed to set permissions for Docker socket. Please check your permissions."
    exit 1
  }
fi

# Step 1: Build the Spring Boot JAR file using Maven (this step is handled inside the Dockerfile now)
echo "Building Spring Boot application with Maven..."
./mvnw clean package -DskipTests || {
  echo "Maven build failed. Please check your Maven setup and try again."
  exit 1
}

# Step 2: Ensure the JAR file exists (checks if it exists before proceeding)
if [ ! -f target/*.jar ]; then
  echo "JAR file not found in target/ directory. Aborting..."
  exit 1
fi

# Step 3: Build the Docker image from the Dockerfile
echo "Building Docker image..."
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_TAG . || {
  echo "Docker build failed. Exiting..."
  exit 1
}

# Step 4: Stop and remove any existing container with the same name
echo "Stopping and removing any existing container..."
if [ $(docker ps -q -f name=spring-boot-app-container) ]; then
  docker stop spring-boot-app-container || echo "Failed to stop the existing container."
  docker rm spring-boot-app-container || echo "Failed to remove the existing container."
else
  echo "No existing container found, skipping stop and remove."
fi

# Step 5: Deploy the Docker container
echo "Deploying Docker container..."
docker run -d --name spring-boot-app-container -p 8081:8081 $DOCKER_IMAGE_NAME:$DOCKER_TAG || {
  echo "Failed to deploy the Docker container."
  exit 1
}

# Step 6: Verify if the container is running
echo "Checking if the Spring Boot app container is running on port 8081..."
if docker ps | grep spring-boot-app-container > /dev/null; then
  echo "Spring Boot app is successfully running in Docker on port 8081."
else
  echo "Spring Boot app container failed to start. Please check the logs for details."
fi
