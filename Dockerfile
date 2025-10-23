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
# !!! QUAN TRỌNG: Thay đổi 'your-app-name.jar' !!!
COPY --from=build /app/target/your-app-name.jar .

# Mở port mà ứng dụng của bạn chạy (ví dụ: 8080)
EXPOSE 8080

# Lệnh để chạy ứng dụng
# !!! QUAN TRỌNG: Thay đổi 'your-app-name.jar' !!!
CMD ["java", "-jar", "your-app-name.jar"]