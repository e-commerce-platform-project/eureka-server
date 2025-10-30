FROM maven:4.0.0-rc-4-eclipse-temurin-17-alpine AS build

COPY src src
COPY pom.xml pom.xml

RUN mvn clean package


FROM bellsoft/liberica-openjdk-alpine:17

RUN adduser --system spring-boot && addgroup --system spring-boot && adduser spring-boot spring-boot
USER spring-boot

WORKDIR /app

COPY --from=build target/*.jar ./app.jar

ENTRYPOINT ["java", "-jar", "./app.jar"]