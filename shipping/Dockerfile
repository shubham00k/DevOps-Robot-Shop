# ---------- STAGE 1: Build ----------
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /opt/shipping
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn package -DskipTests

# ---------- STAGE 2: Run ----------
FROM eclipse-temurin:17-jre-alpine

WORKDIR /opt/shipping
ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql
EXPOSE 8080

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar

CMD ["java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar"]
