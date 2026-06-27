CREATE DATABASE IF NOT EXISTS stayease;
USE stayease;


CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,

    hotel_name VARCHAR(150) NOT NULL,

    city_id INT NOT NULL,

    address VARCHAR(255) NOT NULL,

    description TEXT,

    star_rating DECIMAL(2,1) CHECK (star_rating BETWEEN 1.0 AND 5.0),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id)
        REFERENCES cities(city_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    capacity INT NOT NULL CHECK (capacity > 0)
);

CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,

    hotel_id INT NOT NULL,

    room_type_id INT NOT NULL,

    room_number VARCHAR(20) NOT NULL,

    price DECIMAL(10,2) NOT NULL CHECK(price > 0),

    status ENUM('available','occupied','maintenance')
           DEFAULT 'available',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_room_hotel
        FOREIGN KEY (hotel_id)
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_room_type
        FOREIGN KEY (room_type_id)
        REFERENCES room_types(room_type_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    UNIQUE(hotel_id, room_number)
);

CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    room_id INT NOT NULL,

    check_in DATE NOT NULL,

    check_out DATE NOT NULL,

    total_amount DECIMAL(10,2) NOT NULL CHECK(total_amount >= 0),

    booking_status ENUM(
        'pending',
        'confirmed',
        'cancelled',
        'completed'
    ) DEFAULT 'pending',

    booked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_booking_room
        FOREIGN KEY(room_id)
        REFERENCES rooms(room_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CHECK (check_out > check_in)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT NOT NULL,

    amount DECIMAL(10,2) NOT NULL CHECK (amount >= 0),

    payment_method ENUM(
        'credit_card',
        'debit_card',
        'upi',
        'net_banking'
    ) NOT NULL,

    payment_status ENUM(
        'pending',
        'successful',
        'failed',
        'refunded'
    ) DEFAULT 'pending',

    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_booking
        FOREIGN KEY (booking_id)
        REFERENCES bookings(booking_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,

    user_id INT NOT NULL,

    hotel_id INT NOT NULL,

    rating INT NOT NULL CHECK(rating BETWEEN 1 AND 5),

    comment TEXT,

    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_user
        FOREIGN KEY(user_id)
        REFERENCES users(user_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_review_hotel
        FOREIGN KEY(hotel_id)
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE
);

CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,

    amenity_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE hotel_amenities (

    hotel_id INT,

    amenity_id INT,

    PRIMARY KEY(hotel_id, amenity_id),

    CONSTRAINT fk_hotelamenity_hotel
        FOREIGN KEY(hotel_id)
        REFERENCES hotels(hotel_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_hotelamenity_amenity
        FOREIGN KEY(amenity_id)
        REFERENCES amenities(amenity_id)
        ON DELETE CASCADE
);

