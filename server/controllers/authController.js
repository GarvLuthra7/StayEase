const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.register = async (req, res) => {
    try {

        const { full_name, email, password, phone } = req.body;

        if (!full_name || !email || !password || !phone) {
            return res.status(400).json({
                message: "Please fill all fields"
            });
        }

        
        db.query(
            "SELECT * FROM users WHERE email = ?",
            [email],
            async (err, result) => {

               if (err) {

    if (err.code === "ER_DUP_ENTRY") {
        return res.status(400).json({
            message: "Phone number already registered"
        });
    }

    return res.status(500).json({
        message: "Database Error"
    });
}

                if (result.length > 0) {
                    return res.status(400).json({
                        message: "Email already registered"
                    });
                }

                const hashedPassword = await bcrypt.hash(password, 10);

                db.query(
                    `INSERT INTO users(full_name,email,password_hash,phone)
                     VALUES(?,?,?,?)`,
                    [full_name, email, hashedPassword, phone],

                    (err, result) => {

                        if (err) {
                            return res.status(500).json(err);
                        }

                        res.status(201).json({
                            message: "User Registered Successfully"
                        });

                    }

                );

            }

        );

    } catch (error) {

        res.status(500).json(error);

    }
};

exports.login = async (req, res) => {

    try {

        const { email, password } = req.body;

        if (!email || !password) {
            return res.status(400).json({
                message: "Email and Password are required"
            });
        }

        db.query(
            "SELECT * FROM users WHERE email=?",
            [email],
            async (err, result) => {

                if (err) {
                    return res.status(500).json({
                        message: "Database Error"
                    });
                }

                if (result.length === 0) {
                    return res.status(401).json({
                        message: "Invalid Email"
                    });
                }

                const user = result[0];

                const isMatch = await bcrypt.compare(
                    password,
                    user.password_hash
                );

                if (!isMatch) {
                    return res.status(401).json({
                        message: "Invalid Password"
                    });
                }

                const token = jwt.sign(

                    {
                        id: user.user_id,
                        email: user.email,
                        role: user.role
                    },

                    process.env.JWT_SECRET,

                    {
                        expiresIn: "24h"
                    }

                );

                res.status(200).json({

                    message: "Login Successful",

                    token,

                    user: {

                        id: user.user_id,
                        name: user.full_name,
                        email: user.email,
                        role: user.role

                    }

                });

            }

        );

    }

    catch (error) {

        res.status(500).json(error);

    }

};