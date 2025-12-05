# Dockerfile
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# Copy pom.xml và tải dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code và build
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy WAR file từ builder
COPY --from=builder /app/target/*.war ./app.war

# Tạo thư mục cho ứng dụng
RUN mkdir -p /app/webapps

# Giải nén WAR file (cần thiết cho Jetty/Tomcat embedded)
RUN unzip app.war -d /app/webapps/ROOT && rm app.war

# Expose port (Railway sẽ set biến PORT)
EXPOSE 8080

# Install unzip nếu cần
RUN apk add --no-cache unzip

# Command để chạy embedded server
CMD ["java", "-cp", "/app/webapps/ROOT/WEB-INF/lib/*:/app/webapps/ROOT/WEB-INF/classes", \
     "com.yourpackage.MainLauncher"]
