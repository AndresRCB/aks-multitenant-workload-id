FROM --platform=linux/amd64 mcr.microsoft.com/openjdk/jdk:11-ubuntu
COPY --chown=root:root ../aks-demo-ehclient/target/*.jar /app/ehclient.jar
EXPOSE 8080
WORKDIR /app
ENTRYPOINT ["java", "-jar", "/app/ehclient.jar"]