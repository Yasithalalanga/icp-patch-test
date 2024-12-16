# Use a Linux base image
FROM ubuntu:20.04

# Install JDK version 11 and required dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk sudo \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr
ENV PATH=$JAVA_HOME/bin:$PATH

# Create a user and group for running the application
RUN groupadd --gid 10014 choreo && \
    useradd --no-create-home --uid 10014 --gid choreo --shell /usr/sbin/nologin choreouser

# Copy application files to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Switch to the application user
USER 10014

# Expose the application port
EXPOSE 9743

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "/app/bin/dashboard.sh"]
