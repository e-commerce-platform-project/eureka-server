FROM maven:4.0.0-rc-4-eclipse-temurin-17-alpine AS build

WORKDIR /build

COPY pom.xml .
# Кэшируем зависимости
RUN mvn dependency:go-offline

COPY src src
RUN mvn clean package

# Второй этап — runtime
FROM bellsoft/liberica-openjdk-alpine:17

RUN apk add --no-cache curl

# Создаём пользователя и группу
RUN addgroup --system spring-boot && adduser --system spring-boot --ingroup spring-boot

# Создаём директорию и устанавливаем права
RUN mkdir -p /app && chown spring-boot:spring-boot /app
WORKDIR /app

# Копируем JAR с правами пользователя
COPY --from=build --chown=spring-boot:spring-boot /build/target/*.jar ./app.jar

USER spring-boot

ENTRYPOINT ["java", "-jar", "/app/app.jar"]