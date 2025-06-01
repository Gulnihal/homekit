const mongoose = require("mongoose");

const deviceDataSchema = new mongoose.Schema({
  temp: Number,
  hum: Number,
  pulse: Number,
  gas: Number,
});

const deviceSchema = mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
    unique: true,
  },
  wifi: {
    type: String,
    required: true,
  },
  pass: {
    type: String,
    required: true,
  },
  data: [deviceDataSchema], // Embedded data array
});

const Device = mongoose.model("Device", deviceSchema);
module.exports = { Device, deviceSchema };
