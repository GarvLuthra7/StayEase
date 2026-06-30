USE stayease;

DELIMITER $$

-- ==========================================
-- Trigger 1 : Occupy room after booking
-- ==========================================

CREATE TRIGGER room_booked
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
UPDATE rooms
SET status='occupied'
WHERE room_id=NEW.room_id;
END $$

-- ==========================================
-- Trigger 2 : Make room available after cancellation
-- ==========================================

CREATE TRIGGER room_cancelled
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
IF NEW.booking_status='cancelled' THEN
UPDATE rooms
SET status='available'
WHERE room_id=NEW.room_id;
END IF;
END $$

DELIMITER ;