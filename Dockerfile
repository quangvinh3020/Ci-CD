# Giai đoạn 1: Build ứng dụng (dùng Maven)
# Sử dụng image Maven chính thức với JDK 17
FROM maven:3.8-eclipse-temurin-17 AS build

# Tạo thư mục làm việc
WORKDIR /app

# Copy file pom.xml và tải dependencies (để tận dụng cache)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy toàn bộ code và build
COPY src ./src
RUN mvn clean install

# Giai đoạn 2: Chạy ứng dụng (dùng image JRE gọn nhẹ)
# Sử dụng image JRE 17 chính thức
FROM eclipse-temurin:17-jre-focal

# Tạo thư mục làm việc
WORKDIR /app

# Copy file .jar đã được build từ giai đoạn 1
# ĐÃ SỬA: Dùng đúng tên file .jar từ pom.xml
COPY --from=build /app/target/lab5-cicd-0.0.1-SNAPSHOT.jar .

# Mở port mà ứng dụng của bạn chạy (8080 là port mặc định của Spring Boot)
EXPOSE 8080

# Lệnh để chạy ứng dụng
# ĐÃ SỬA: Dùng đúng tên file .jar từ pom.xml
CMD ["java", "-jar", "lab5-cicd-0.0.1-SNAPSHOT.jar"]
