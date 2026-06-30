USE stayease;

-- ==========================================
-- View 1 : Available Rooms
-- ==========================================

CREATE VIEW available_rooms AS
SELECT
r.room_id,
h.hotel_name,
r.room_number,
rt.type_name,
r.price
FROM rooms r
JOIN hotels h
ON r.hotel_id=h.hotel_id
JOIN room_types rt
ON r.room_type_id=rt.room_type_id
WHERE r.status='available';

-- ==========================================
-- View 2 : Booking Summary
-- ==========================================

CREATE VIEW booking_summary AS
SELECT
b.booking_id,
u.full_name,
h.hotel_name,
r.room_number,
b.check_in,
b.check_out,
b.total_amount,
b.booking_status
FROM bookings b
JOIN users u
ON b.user_id=u.user_id
JOIN rooms r
ON b.room_id=r.room_id
JOIN hotels h
ON r.hotel_id=h.hotel_id;

-- ==========================================
-- View 3 : Hotel Ratings
-- ==========================================

CREATE VIEW hotel_ratings AS
SELECT
h.hotel_name,
AVG(rv.rating) AS average_rating,
COUNT(rv.review_id) AS total_reviews
FROM hotels h
LEFT JOIN reviews rv
ON h.hotel_id=rv.hotel_id
GROUP BY h.hotel_name;

-- ==========================================
-- View 4 : Hotel Revenue
-- ==========================================

CREATE VIEW hotel_revenue AS
SELECT
h.hotel_name,
SUM(b.total_amount) AS total_revenue
FROM hotels h
JOIN rooms r
ON h.hotel_id=r.hotel_id
JOIN bookings b
ON r.room_id=b.room_id
GROUP BY h.hotel_name;

-- ==========================================
-- View 5 : Customer Booking Count
-- ==========================================

CREATE VIEW customer_booking_count AS
SELECT
u.user_id,
u.full_name,
COUNT(b.booking_id) AS total_bookings
FROM users u
LEFT JOIN bookings b
ON u.user_id=b.user_id
GROUP BY u.user_id,u.full_name;