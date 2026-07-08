const db = require("../config/db");

exports.getAllHotels = (req, res) => {

    const { city, rating } = req.query;

    let query = `
        SELECT
            h.hotel_id,
            h.hotel_name,
            c.city_name,
            h.address,
            h.description,
            h.star_rating
        FROM hotels h
        JOIN cities c
        ON h.city_id = c.city_id
        WHERE 1=1
    `;

    const values = [];

    if (city) {
        query += " AND c.city_name = ?";
        values.push(city);
    }

    if (rating) {
        query += " AND h.star_rating >= ?";
        values.push(rating);
    }

    query += " ORDER BY h.star_rating DESC";

    db.query(query, values, (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        res.status(200).json(result);

    });

};

exports.getHotelById = (req, res) => {

    const { id } = req.params;

    const query = `
        SELECT
            h.hotel_id,
            h.hotel_name,
            c.city_name,
            h.address,
            h.description,
            h.star_rating
        FROM hotels h
        JOIN cities c
        ON h.city_id = c.city_id
        WHERE h.hotel_id = ?
    `;

    db.query(query, [id], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        if (result.length === 0) {
            return res.status(404).json({
                message: "Hotel Not Found"
            });
        }

        res.status(200).json(result[0]);

    });

};

exports.searchHotels = (req, res) => {

    const { city } = req.query;

    if (!city) {
        return res.status(400).json({
            message: "City parameter is required"
        });
    }

    const query = `
        SELECT
            h.hotel_id,
            h.hotel_name,
            c.city_name,
            h.address,
            h.description,
            h.star_rating
        FROM hotels h
        JOIN cities c
        ON h.city_id = c.city_id
        WHERE c.city_name = ?
    `;

    db.query(query, [city], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        res.status(200).json(result);

    });

};

exports.filterHotels = (req, res) => {

    const { rating } = req.query;

    if (!rating) {
        return res.status(400).json({
            message: "Rating parameter is required"
        });
    }

    const query = `
        SELECT
            h.hotel_id,
            h.hotel_name,
            c.city_name,
            h.address,
            h.description,
            h.star_rating
        FROM hotels h
        JOIN cities c
        ON h.city_id = c.city_id
        WHERE h.star_rating >= ?
        ORDER BY h.star_rating DESC
    `;

    db.query(query, [rating], (err, result) => {

        if (err) {
            return res.status(500).json({
                message: "Database Error"
            });
        }

        res.status(200).json(result);

    });

};