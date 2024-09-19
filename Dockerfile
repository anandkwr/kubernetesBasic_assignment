# creating jar from maven
FROM maven:3.8.3-openjdk-17-slim AS stage1
WORKDIR /home/app
COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package -DskipTests

#Create docker image using jar
FROM openjdk:17-jdk-slim
EXPOSE 8000
COPY --from=stage1 /home/app/target/kubernetesBasicDemo-0.0.1-SNAPSHOT.jar app.jar
ENTRYPOINT ["sh", "-c", "java -jar /app.jar"]
