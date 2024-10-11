# Backend Dockerfile (Task/Dockerfile)
# Stage 1: Builder
FROM maven:3.8.7-openjdk-18-slim AS build
WORKDIR /build
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM amazoncorretto:17
ARG PROFILE=dev
ARG APP_VERSION=1.0.0
WORKDIR /app
COPY --from=build /build/target/*.jar ./app.jar
EXPOSE 8080
ENV DB_URL=jdbc:mysql://mysql:3306/task_db
ENV ACTIVE_PROFILE=$PROFILE
ENV JAR_VERSION=$APP_VERSION
CMD ["java", "-jar", "-Dspring.profiles.active=${ACTIVE_PROFILE}", "-Dspring.datasource.url=${DB_URL}", "app.jar"]
