const express = require("express");
const deviceRouter = express.Router();
const auth = require("../middlewares/auth");
const User = require("../models/user");
const { Device } = require("../models/device");

// ESP32 CONSTS
const espIpAddress = "http://192.168.111.226/data"; //TODO change required

deviceRouter.post("/api/device/refresh", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user.device) {
      return res.status(400).json({ msg: "No device found for user." });
    }

    const device = await Device.findById(user.device); // 🔑 Gerçek Device belgesini al

    const raw = await fetch(espIpAddress);
    let rawText = await raw.text();
    rawText = rawText.replace(/:nan/g, ":null");

    let rawData;
    try {
      rawData = JSON.parse(rawText);
    } catch (parseErr) {
      return res.status(500).json({ error: "JSON parsing failed after nan->null replace." });
    }

    const cleanedData = rawData
      .filter(entry => entry.temp !== null && entry.hum !== null)
      .map(entry => ({
        ...entry,
        timestamp: new Date(),
      }));

    if (cleanedData.length === 0) {
      return res.status(400).json({ msg: "No valid data fetched." });
    }

    device.data.push(...cleanedData);      // 🔧 Gerçek belgeye verileri ekle
    await device.save();                   // ✅ Artık gerçekten MongoDB’ye kaydedilir

    res.status(200).json({
      msg: "Device data refreshed successfully.",
      newRecords: cleanedData.length,
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

deviceRouter.get("/api/device/data", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user).populate("device"); // populate ile device'i gerçek belge yap

    if (!user.device) {
      return res.status(404).json({ msg: "Device not found." });
    }

    res.status(200).json({
      deviceName: user.device.name,
      dataCount: user.device.data.length,
      data: user.device.data,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = { 
  deviceRouter, 
  espIpAddress,
};
