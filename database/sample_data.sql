INSERT INTO cities (city_name) VALUES
('Delhi'),
('Mumbai'),
('Bengaluru'),
('Hyderabad'),
('Chennai'),
('Pune'),
('Jaipur'),
('Kolkata');

INSERT INTO amenities (amenity_name) VALUES
('Free WiFi'),
('Swimming Pool'),
('Gym'),
('Spa'),
('Restaurant'),
('Parking'),
('Airport Shuttle'),
('Bar');

INSERT INTO room_types (type_name, capacity) VALUES
('Standard',2),
('Deluxe',3),
('Suite',4),
('Family',5);

INSERT INTO users
(full_name,email,password_hash,phone,role)
VALUES
('Garv Luthra','garv@example.com','hashed_password1','9876543210','customer'),
('Rahul Sharma','rahul@example.com','hashed_password2','9876543211','customer'),
('Priya Singh','priya@example.com','hashed_password3','9876543212','customer'),
('Ananya Gupta','ananya@example.com','hashed_password4','9876543213','customer'),
('Admin User','admin@stayease.com','hashed_password5','9876543214','admin');

INSERT INTO hotels
(hotel_name,city_id,address,description,star_rating)
VALUES
('The Imperial',1,'Connaught Place, Delhi','Luxury hotel in Delhi',5.0),
('Taj Palace',1,'Chanakyapuri, Delhi','Premium stay experience',5.0),
('The Oberoi Mumbai',2,'Nariman Point, Mumbai','Sea-facing luxury hotel',5.0),
('ITC Gardenia',3,'MG Road, Bengaluru','Business luxury hotel',4.8),
('Novotel Hyderabad',4,'Hitech City, Hyderabad','Modern business hotel',4.5);

INSERT INTO hotel_amenities VALUES
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,1),(2,3),(2,5),(2,6),
(3,1),(3,2),(3,5),(3,8),
(4,1),(4,3),(4,6),
(5,1),(5,2),(5,7);

INSERT INTO rooms
(hotel_id,room_type_id,room_number,price,status)
VALUES
(1,1,'101',4500,'available'),
(1,2,'102',6500,'available'),
(1,3,'201',9000,'occupied'),

(2,1,'101',5000,'available'),
(2,2,'102',7000,'maintenance'),

(3,3,'301',12000,'available'),
(3,4,'401',15000,'available'),

(4,1,'101',4000,'available'),
(4,2,'102',5500,'occupied'),

(5,1,'101',4200,'available');

INSERT INTO bookings
(user_id,room_id,check_in,check_out,total_amount,booking_status)
VALUES
(1,1,'2026-07-05','2026-07-08',13500,'confirmed'),
(2,3,'2026-07-10','2026-07-12',18000,'completed'),
(3,6,'2026-07-15','2026-07-18',36000,'pending'),
(4,8,'2026-07-20','2026-07-22',8000,'confirmed');

INSERT INTO payments
(booking_id,amount,payment_method,payment_status)
VALUES
(1,13500,'upi','successful'),
(2,18000,'credit_card','successful'),
(3,36000,'debit_card','pending'),
(4,8000,'net_banking','successful');

INSERT INTO reviews
(user_id,hotel_id,rating,comment)
VALUES
(1,1,5,'Excellent hospitality and service.'),
(2,3,4,'Beautiful rooms and great location.'),
(4,4,5,'Loved the stay. Highly recommended.');