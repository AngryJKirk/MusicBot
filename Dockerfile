FROM maven:3.8.5-openjdk-17-slim AS build

WORKDIR /app

COPY ./pom.xml .

# verify --fail-never works much better than dependency:resolve or dependency:go-offline
RUN mvn clean verify --fail-never

COPY ./src ./src

RUN mvn package -DskipTests

FROM openjdk:17-jdk-slim

WORKDIR /app

COPY --from=build /app/target/JMusicBot-0.3.8-All.jar .

COPY config.txt .

ENTRYPOINT ["java","-Dnogui=true","-jar","JMusicBot-0.3.8-All.jar"]
