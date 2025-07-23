# Stage 1: Build the plugin
FROM maven:3.9.6-eclipse-temurin-17 as builder

# Set working directory inside the container
WORKDIR /app

# Copy all plugin source code to the container
COPY . .

# Build the plugin (skip tests to speed up if needed)
RUN mvn clean install -DskipTests

# Stage 2: Run Jenkins with the built plugin
FROM jenkins/jenkins:lts-jdk17

USER root

# Create plugin directory and copy built .hpi
COPY --from=builder /app/target/ldap.hpi /usr/share/jenkins/ref/plugins/ldap.hpi

# Ensure correct permissions
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins

USER jenkins
