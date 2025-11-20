CREATE DATABASE IF NOT EXISTS cities;

CREATE USER IF NOT EXISTS 'shipping'@'%' IDENTIFIED BY 'shipping';
GRANT ALL PRIVILEGES ON cities.* TO 'shipping'@'%';
FLUSH PRIVILEGES;

USE cities;

CREATE TABLE IF NOT EXISTS shipping_cities (
    uuid BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    country_code VARCHAR(5),
    city VARCHAR(50),
    name VARCHAR(50),
    region VARCHAR(50),
    latitude DOUBLE,
    longitude DOUBLE
);

INSERT INTO shipping_cities (country_code, city, name, region, latitude, longitude) VALUES
('IN', 'Mumbai', 'India', 'MH', 19.0760, 72.8777),
('US', 'New York', 'United States', 'NY', 40.7128, -74.0060),
('UK', 'London', 'United Kingdom', 'LN', 51.5074, -0.1278),
('CA', 'Toronto', 'Canada', 'ON', 43.6532, -79.3832),
('AU', 'Sydney', 'Australia', 'NSW', -33.8688, 151.2093);

CREATE TABLE IF NOT EXISTS shipping_rates (
    weight INT NOT NULL,
    price FLOAT NOT NULL
);

INSERT INTO shipping_rates (weight, price) VALUES
(1, 5),
(5, 15),
(10, 30),
(20, 50);

