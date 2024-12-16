# Use a Linux base image
FROM ubuntu:20.04

# Ensure root privileges for these commands
USER root

# Install JDK version 11 and required dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    sudo \
    && apt-get clean

# Add JAVA_HOME to the PATH
ENV JAVA_HOME=/usr
ENV PATH=$JAVA_HOME/bin:$PATH

# Create a user and group for running the application
RUN addgroup --gid 10014 choreo && \
    adduser --disabled-password --uid 10014 --ingroup choreo --gecos "" choreouser

# Copy all files from the current directory to the /app directory in the container
COPY . /app

# Pre-create all required directories and set permissions
RUN mkdir -p /home/choreouser/apps/logs && \
    mkdir -p /app/logs && \
    mkdir -p /app/backup && \
    chown -R choreouser:choreo /home/choreouser /app && \
    chmod -R 755 /app && \
    chmod -R 777 /app/logs && \
    chmod -R 777 /app/backup

# Set the working directory to /app
WORKDIR /app

# Switch to choreouser (userid 10014)
USER 10014

# Expose port 9743
EXPOSE 9743

# Ensure the entrypoint script has executable permissions
RUN chmod +x /app/bin/dashboard.sh

# Run the build script in /bin/dashboard.sh (entrypoint)
ENTRYPOINT ["/bin/bash", "/app/bin/dashboard.sh"]
