#!/bin/bash

# Step 1: Build the Spring Boot JAR file using Maven (this step is handled inside the Dockerfile now)
echo "Building Spring Boot application with Maven..."
./mvnw clean package -DskipTests # Skips tests to speed up build

# Step 2: Build the Docker image from the Dockerfile
echo "Building Docker image..."
DOCKER_IMAGE_NAME="spring-boot-app"
DOCKER_TAG="latest"

# Ensure the JAR file exists (usefully checks if it exists before proceeding)
if [ ! -f target/*.jar ]; then
  echo "JAR file not found in target/ directory. Aborting..."
  exit 1
fi

# Build the Docker image
docker build -t $DOCKER_IMAGE_NAME:$DOCKER_TAG .

# Step 3: Stop and remove the existing container if it's running
echo "Stopping and removing any existing container..."
# Check if the container exists and stop/remove it
if [ $(docker ps -q -f name=spring-boot-app-container) ]; then
    docker stop spring-boot-app-container
    docker rm spring-boot-app-container
else
    echo "No existing container found, skipping stop and remove."
fi

# Step 4: Deploy the Docker container
echo "Deploying Docker container..."
docker run -d --name spring-boot-app-container -p 8081:8081 $DOCKER_IMAGE_NAME:$DOCKER_TAG

# Step 5: Check if the container is running
echo "Spring Boot app is running in Docker on port 8081."
docker ps | grep spring-boot-app-container
