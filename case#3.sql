DROP DATABASE IF EXISTS tourism;
CREATE DATABASE tourism;
USE tourism;

CREATE TABLE IF NOT EXISTS countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(50) NOT NULL,
    visa_required BOOLEAN DEFAULT FALSE,
    climate VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS tour_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    passport_number VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    registration_date DATE DEFAULT (CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS tours (
    tour_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    country_id INT NOT NULL,
    type_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    max_participants INT,
    current_participants INT DEFAULT 0,
    status ENUM('available', 'completed', 'canceled') DEFAULT 'available',
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (type_id) REFERENCES tour_types(type_id)
);

CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    tour_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    participants INT NOT NULL DEFAULT 1,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('reserved', 'paid', 'canceled') DEFAULT 'reserved',
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    tour_id INT NOT NULL,
    rating INT NOT NULL,
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (tour_id) REFERENCES tours(tour_id)
);

INSERT INTO countries (country_name, visa_required, climate) VALUES
('Турция', FALSE, 'умеренный'),
('Италия', TRUE, 'умеренный'),
('Таиланд', FALSE, 'тропический'),
('Франция', TRUE, 'умеренный'),
('Япония', TRUE, 'умеренный');

INSERT INTO tour_types (type_name, description) VALUES
('Пляжный отдых', 'Отдых на море с проживанием в отеле'),
('Экскурсионный', 'Экскурсии по достопримечательностям'),
('Горнолыжный', 'Отдых на горнолыжных курортах'),
('Гастрономический', 'Знакомство с национальной кухней');

INSERT INTO clients (first_name, last_name, passport_number, phone, email) VALUES
('Иван', 'Иванов', 'AB123456', '+79001234567', 'ivanov@example.com'),
('Мария', 'Петрова', 'CD654321', '+79007654321', 'petrova@example.com'),
('Алексей', 'Сидоров', 'EF789012', '+79161234567', 'sidorov@example.com');

INSERT INTO tours (title, country_id, type_id, start_date, end_date, price, max_participants) VALUES
('Отдых в Анталии', 1, 1, '2024-06-15', '2024-06-22', 1200.00, 20),
('Рим и Флоренция', 2, 2, '2024-07-10', '2024-07-17', 1800.00, 15),
('Горные лыжи в Альпах', 4, 3, '2024-12-20', '2024-12-27', 2100.00, 10),
('Гастротур по Тоскане', 2, 4, '2024-09-05', '2024-09-12', 2500.00, 12);

INSERT INTO bookings (client_id, tour_id, participants, total_price, status) VALUES
(1, 1, 2, 2400.00, 'paid'),
(2, 2, 1, 1800.00, 'reserved'),
(3, 3, 4, 8400.00, 'paid');

INSERT INTO reviews (client_id, tour_id, rating, comment) VALUES
(1, 1, 5, 'Отличный отель и обслуживание!'),
(3, 3, 4, 'Прекрасные склоны, но мало времени для отдыха');

SELECT 'Список стран:' AS message;
SELECT * FROM countries;

SELECT 'Список типов туров:' AS message;
SELECT * FROM tour_types;

SELECT 'Список клиентов:' AS message;
SELECT * FROM clients;

SELECT 'Доступные туры:' AS message;
SELECT * FROM tour_types;

SELECT 'Бронирования:' AS message;
SELECT b.booking_id, 
       CONCAT(cl.first_name, ' ', cl.last_name) AS client,
       t.title AS tour,
       b.booking_date,
       b.participants,
       b.total_price,
       b.status
FROM bookings b
JOIN clients cl ON b.client_id = cl.client_id
JOIN tours t ON b.tour_id = t.tour_id;

SELECT 'Отзывы:' AS message;
SELECT r.review_id,
       CONCAT(cl.first_name, ' ', cl.last_name) AS client,
       t.title AS tour,
       r.rating,
       r.comment,
       r.review_date
FROM reviews r
JOIN clients cl ON r.client_id = cl.client_id
JOIN tours t ON r.tour_id = t.tour_id;