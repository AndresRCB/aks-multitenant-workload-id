FROM --platform=linux/amd64 mcr.microsoft.com/openjdk/jdk:11-ubuntu
COPY target/*.jar /app/app.jar
EXPOSE 8080
WORKDIR /app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]