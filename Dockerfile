# Use the official OpenJDK base image with JDK 17
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the Maven wrapper files and pom.xml to the container
COPY .mvn/ .mvn
COPY mvnw .
COPY pom.xml .

# Make mvnw executable
RUN chmod +x mvnw

# Install Maven dependencies (this avoids re-downloading dependencies every time)
RUN ./mvnw dependency:go-offline

# Copy the source code to the container
COPY src/ /app/src

# Run the Maven build to create the JAR file
RUN ./mvnw clean package -DskipTests

# Copy the JAR file from the build context into the container as app.jar
# Ensure the path to the JAR is correct, and this assumes the output JAR is in the target directory
COPY target/*.jar app.jar

# Set the entry point to run the Spring Boot app with Java
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Expose the application port (if needed)
EXPOSE 8081
