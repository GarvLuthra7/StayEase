require("dotenv").config();

const express = require("express");

const cors = require("cors");

const db = require("./config/db");

const authRoutes = require("./routes/authRoutes");

const hotelRoutes = require("./routes/hotelRoutes");

const bookingRoutes = require("./routes/bookingRoutes");

const reviewRoutes = require("./routes/reviewRoutes");

const app = express();

app.use(cors());

app.use(express.json());

app.use("/api/auth", authRoutes);

app.use("/api/hotels", hotelRoutes);

app.use("/api/bookings", bookingRoutes);

app.use("/api/reviews", reviewRoutes);

app.get("/", (req, res) => {
    res.send("🚀 Welcome to StayEase Backend");
});

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
});