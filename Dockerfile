# syntax=docker/dockerfile:1

FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /workspace/backend

COPY backend/pom.xml ./
RUN mvn -q -DskipTests dependency:go-offline

COPY backend/src ./src
RUN mvn -q -DskipTests package


FROM eclipse-temurin:17-jre

WORKDIR /app

ENV TZ=Asia/Shanghai \
    SPRING_PROFILES_ACTIVE=docker \
    SERVER_PORT=8081 \
    UPLOAD_PATH=/app/uploads \
    JAVA_OPTS=""

RUN mkdir -p /app/uploads

COPY --from=build /workspace/backend/target/*.jar /app/app.jar

EXPOSE 8080 8081

ENTRYPOINT ["sh", "-c", "java ${JAVA_OPTS} -jar /app/app.jar --spring.profiles.active=${SPRING_PROFILES_ACTIVE} --server.port=${SERVER_PORT}"]
