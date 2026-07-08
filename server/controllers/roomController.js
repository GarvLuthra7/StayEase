const db = require("../config/db");

exports.getRoomsByHotel = (req, res) => {

    const hotelId = req.params.id;

    const query = `
        SELECT
            r.room_id,
            r.room_number,
            rt.type_name,
            rt.capacity,
            r.price,
            r.status
        FROM rooms r
        JOIN room_types rt
            ON r.room_type_id = rt.room_type_id
        WHERE r.hotel_id = ?
        ORDER BY r.price ASC
    `;

    db.query(query, [hotelId], (err, result) => {

        if (err) {

            return res.status(500).json({
                message: "Database Error"
            });

        }

        res.status(200).json(result);

    });

};