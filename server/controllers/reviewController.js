const db = require("../config/db");

exports.addReview = (req, res) => {

    const { hotel_id, rating, comment } = req.body;

    const userId = req.user.id;

    if (!hotel_id || !rating) {
        return res.status(400).json({
            message: "Hotel ID and Rating are required"
        });
    }

    const query = `
        INSERT INTO reviews
        (hotel_id, user_id, rating, comment)
        VALUES (?, ?, ?, ?)
    `;

    db.query(
        query,
        [hotel_id, userId, rating, comment],
        (err, result) => {

            if (err) {
                return res.status(500).json({
                    message: "Database Error"
                });
            }

            res.status(201).json({
                message: "Review Added Successfully",
                review_id: result.insertId
            });

        }
    );

};

exports.getHotelReviews = (req, res) => {

    const hotelId = req.params.id;

    const query = `
        SELECT
            u.full_name,
            r.rating,
            r.comment,
            r.created_at
        FROM reviews r
        JOIN users u
            ON r.user_id = u.user_id
        WHERE r.hotel_id = ?
        ORDER BY r.created_at DESC
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