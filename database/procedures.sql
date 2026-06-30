USE stayease;

DELIMITER $$

-- ==========================================
-- Procedure 1 : Get Hotels by City
-- ==========================================

CREATE PROCEDURE GetHotelsByCity(IN city VARCHAR(100))
BEGIN
SELECT
h.hotel_name,
h.star_rating
FROM hotels h
JOIN cities c
ON h.city_id=c.city_id
WHERE c.city_name=city;
END $$

-- ==========================================
-- Procedure 2 : Available Rooms in Hotel
-- ==========================================

CREATE PROCEDURE GetAvailableRooms(IN hotel INT)
BEGIN
SELECT
room_number,
price
FROM rooms
WHERE hotel_id=hotel
AND status='available';
END $$

-- ==========================================
-- Procedure 3 : User Booking History
-- ==========================================

CREATE PROCEDURE UserBookingHistory(IN uid INT)
BEGIN
SELECT *
FROM bookings
WHERE user_id=uid;
END $$

DELIMITER ;