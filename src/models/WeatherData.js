// src/models/WeatherData.js
const mongoose = require('mongoose');

const weatherDataSchema = new mongoose.Schema({
  timestamp: { type: Date, required: true }, // This will be the time field
  date: { type: String, required: true }, // Optional, you can keep this for daily aggregates
  temperature: { type: Number, required: true },
  condition: { type: String, required: true },
});

// Use a time series collection
module.exports = mongoose.model('WeatherData', weatherDataSchema);
