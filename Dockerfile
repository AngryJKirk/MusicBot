FROM maven:3.8.5-openjdk-17-slim AS build

WORKDIR /app

COPY ./pom.xml .

# verify --fail-never works much better than dependency:resolve or dependency:go-offline
RUN mvn clean verify --fail-never

COPY ./src ./src

RUN mvn package -DskipTests

FROM openjdk:17-jdk-slim

COPY --from=build /app/target/JMusicBot-Snapshot-All.jar /usr/local/lib/JMusicBot-Snapshot-All.jar

COPY config.txt /usr/local/lib/config.txt

ENTRYPOINT ["java","-Dnogui=true","-jar","/usr/local/lib/JMusicBot-Snapshot-All.jar"]
