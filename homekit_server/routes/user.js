const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const { Device, espIpAddress } = require("../models/device");
const User = require("../models/user");
const { weatherKey } = require("../config");

// WEATHER
const axios = require('axios');
let city = 'istanbul';
var weatherData;
axios.get(`http://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${weatherKey}`)
  .then(response => {
    weatherData = response.data;
  })
  .catch(error => {
    console.log(error);
  });

userRouter.get("/get-weather-data", auth, async (req, res) => {
  try {

    res.status(200).json({
      weatherData: weatherData,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

userRouter.post("/api/add-device", auth, async (req, res) => {
  try {
    const { name, wifi, pass } = req.body;

    if (!name || !wifi || !pass) {
      return res.status(400).json({ msg: "Please provide all device fields." });
    }

    // Optional: Check if the device name is already used globally
    const existingDevice = await Device.findOne({ name });
    if (existingDevice) {
      return res.status(400).json({ msg: "Device name already exists." });
    }

    // send Wi-Fi info to ESP32
    const espURL = "http://192.168.4.1/creds"; // ESP32 SoftAP adresi
    let espResponse;
    try {
      espResponse = await fetch(espURL, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({ ssid: wifi, password: pass })
      });

      if (!espResponse.ok) {
        return res.status(500).json({ msg: "ESP32'dan onay alınamadı." });
      }
    } catch (err) {
      return res.status(500).json({ msg: "ESP32'ye erişilemedi: " + err.message });
    }

    // Fetch device data from internal IP (or external sensor endpoint)
    let fetchedData = [];
    try {
      const response = await fetch(espIpAddress);
      let rawData = await response.json();

      // Filter out entries with NaN temp or hum
      fetchedData = rawData
        .filter(entry => !isNaN(entry.temp) && !isNaN(entry.hum))
        .map(entry => ({
          ...entry,
          timestamp: new Date(), // Add timestamp for schema
        }));
    } catch (fetchErr) {
      console.warn("Veri çekilirken hata oluştu, cihaz veri alanı boş kalacak:", fetchErr.message);
    }

    // Create and validate the device object
    const newDevice = new Device({
      name,
      wifi,
      pass,
      data: fetchedData,
    });

    // Save device to device collection
    await newDevice.save();

    // Attach to user
    const user = await User.findById(req.user);
    user.device = newDevice;
    await user.save();

    res.status(200).json({
      msg: "Device added successfully.",
      device: user.device,
      dataFetched: fetchedData.length,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

userRouter.delete("/api/remove-device", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user.device) {
      return res.status(400).json({ msg: "No device to remove." });
    }

    const deviceName = user.device.name;

    // Remove device from user
    user.device = undefined;
    await user.save();

    // Optional: Delete from global device registry
    await Device.findOneAndDelete({ name: deviceName });

    res.status(200).json({ msg: "Device removed successfully." });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = userRouter;
