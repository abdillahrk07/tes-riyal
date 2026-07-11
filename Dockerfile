FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Salin pom.xml
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline -B

# Salin source code
COPY src ./src

# Build JAR
RUN mvn package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

# Copy JAR dari stage build
COPY --from=build /app/target/*.jar app.jar

# Jalankan aplikasi
ENTRYPOINT ["java", "-jar", "app.jar"]