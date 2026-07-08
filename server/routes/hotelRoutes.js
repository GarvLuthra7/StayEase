const express = require("express");

const router = express.Router();

const hotelController = require("../controllers/hotelController");

const roomController = require("../controllers/roomController");

router.get("/search", hotelController.searchHotels);

router.get("/filter", hotelController.filterHotels);

router.get("/", hotelController.getAllHotels);

router.get("/:id/rooms", roomController.getRoomsByHotel);

router.get("/:id", hotelController.getHotelById);

module.exports = router;