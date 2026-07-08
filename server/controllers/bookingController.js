const db = require("../config/db");

exports.bookRoom = (req, res) => {

    const { room_id, check_in, check_out } = req.body;

    if (!room_id || !check_in || !check_out) {
        return res.status(400).json({
            message: "Please provide room_id, check_in and check_out"
        });
    }



    const roomQuery = `
        SELECT *
        FROM rooms
        WHERE room_id = ?
    `;

    db.query(roomQuery, [room_id], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        if (result.length === 0) {
            return res.status(404).json({
                message: "Room Not Found"
            });
        }

        const room = result[0];

        const bookingCheckQuery = `
            SELECT *
            FROM bookings
            WHERE room_id = ?
            AND booking_status != 'completed'
            AND (
                check_in < ?
                AND check_out > ?
            )
        `;

        db.query(
            bookingCheckQuery,
            [room_id, check_out, check_in],
            (err, bookings) => {

                if (err) {
                    return res.status(500).json({
                        message: "Database Error"
                    });
                }

                if (bookings.length > 0) {
                    return res.status(400).json({
                        message: "Room is already booked for the selected dates"
                    });
                }

                const pricePerNight = room.price;

                const nights = Math.ceil(
                    (new Date(check_out) - new Date(check_in)) /
                    (1000 * 60 * 60 * 24)
                );

                const totalAmount = pricePerNight * nights;

                const insertQuery = `
                    INSERT INTO bookings
                    (user_id, room_id, check_in, check_out, total_amount, booking_status)
                    VALUES (?, ?, ?, ?, ?, 'confirmed')
                `;

                db.query(
                    insertQuery,
                    [
                        req.user.id,
                        room_id,
                        check_in,
                        check_out,
                        totalAmount
                    ],
                    (err, bookingResult) => {

                        if (err) {
                            return res.status(500).json({
                                message: "Booking Failed"
                            });
                        }

                        res.status(201).json({
                            message: "Booking Successful",
                            booking_id: bookingResult.insertId,
                            total_amount: totalAmount
                        });

                    }
                );

            }
        );

    });

};

    exports.getMyBookings = (req, res) => {

    const userId = req.user.id;

    const query = `
        SELECT
            b.booking_id,
            h.hotel_name,
            r.room_number,
            rt.type_name,
            b.check_in,
            b.check_out,
            b.total_amount,
            b.booking_status
        FROM bookings b
        JOIN rooms r
            ON b.room_id = r.room_id
        JOIN hotels h
            ON r.hotel_id = h.hotel_id
        JOIN room_types rt
            ON r.room_type_id = rt.room_type_id
        WHERE b.user_id = ?
        ORDER BY b.check_in DESC
    `;

    db.query(query, [userId], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        res.status(200).json(result);

    });

};

exports.cancelBooking = (req, res) => {

    const bookingId = req.params.id;
    const userId = req.user.id;

    const checkQuery = `
        SELECT *
        FROM bookings
        WHERE booking_id = ?
        AND user_id = ?
    `;

    db.query(checkQuery, [bookingId, userId], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        if (result.length === 0) {
            return res.status(404).json({
                message: "Booking Not Found"
            });
        }

        const updateQuery = `
            UPDATE bookings
            SET booking_status = 'cancelled'
            WHERE booking_id = ?
        `;

        db.query(updateQuery, [bookingId], (err) => {

            if (err) {
                return res.status(500).json({
                    message: "Unable to Cancel Booking"
                });
            }

            res.json({
                message: "Booking Cancelled Successfully"
            });

        });

    });

};