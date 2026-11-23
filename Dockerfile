
# Use Maven and JDK to build the application
FROM maven:3.9-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy project files
COPY pom.xml .

COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Use Tomcat to run the application
FROM tomcat:9.0-jdk17-temurin

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file into Tomcat
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
