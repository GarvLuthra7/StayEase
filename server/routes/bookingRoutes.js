const express = require("express");

const router = express.Router();

const bookingController = require("../controllers/bookingController");

const authMiddleware = require("../middleware/authMiddleware");

router.post(
    "/",
    authMiddleware,
    bookingController.bookRoom
);

router.get(
    "/my",
    authMiddleware,
    bookingController.getMyBookings
);

router.put(
    "/:id/cancel",
    authMiddleware,
    bookingController.cancelBooking
);

module.exports = router;