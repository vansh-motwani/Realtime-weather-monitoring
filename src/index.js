// src/index.js
const { getWeather } = require("./services/weatherService");
const WeatherData = require('./models/WeatherData'); // Import the WeatherData model
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const express = require('express');
const router = express.Router();

const app = express();
app.use(cors());
app.use(bodyParser.json());

//const dailyWeatherData = []; // Store weather data for daily aggregation

async function collectWeatherData(city) {
   
    const weatherData = await getWeather(city);
    console.log("DATA",weatherData)
    const min_temp= weatherData['main']['temp_min']
    const max_temp= weatherData['main']['temp_max']
    const pressure = weatherData['main']['pressure']
    const sea_level = weatherData['main']['sea_level']
    const grnd_level= weatherData['main']['grnd_level']
    const wind_speed = weatherData['wind']['speed']
    const wind_degree = weatherData['wind']['deg']
    const cloud_count = weatherData['clouds']['all']
    const humidity = weatherData['main']['humidity']
  

    const newWeatherData = new WeatherData({
      city,
      min_temp,
      max_temp,
      pressure,
      sea_level,
      grnd_level,
      wind_speed,
      wind_degree,
      cloud_count,
      humidity
    });

    await newWeatherData.save();
    console.log("DATA SAVED")
    
}

async function main() {

  mongoose.connect("mongodb+srv://TEST:12345@mubustest.yfyj3.mongodb.net/weather_app", {
    useNewUrlParser: true,
    useUnifiedTopology: true
  }).then(() => console.log("MongoDB connected"))
    .catch(err => console.log(err));
  
  app.get('/', async (req, res) => {
    const data = await WeatherData.find()
    res.json({data})
    res.send('Backend is activated');
  });

  app.post('/save', (req, res) => {
    const {city} = req.body;
    collectWeatherData(city);
    res.status(201).json({message: 'WEATHER DATA SAVED SUCCESFULLY'}) 
  });
  
  app.post('/live_search', async (req, res) => {
    const {city} = req.body;
    const weatherData = await getWeather(city);
    res.status(201).json({weatherData}) 
  });





  // setInterval(async () => {
  //   const city = "Delhi"; 
  //   await collectWeatherData(city);
  // }, 10000); 
  
}

// async function calculateDailyAggregates() {
//   try {
//     const aggregates = await WeatherData.aggregate([
//       {
//         $group: {
//           _id: { $dateToString: { format: "%Y-%m-%d", date: "$timestamp" } }, // Group by date
//           maxTemp: { $max: "$temperature" },
//           minTemp: { $min: "$temperature" },
//           totalTemp: { $sum: "$temperature" },
//           count: { $sum: 1 },
//           dominantCondition: { $first: "$condition" }, // This can be enhanced for better logic
//         },
//       },
//       {
//         $project: {
//           date: "$_id", // Rename the field
//           averageTemp: { $divide: ["$totalTemp", "$count"] }, // Calculate average
//           maxTemp: 1,
//           minTemp: 1,
//           dominantCondition: 1,
//           _id: 0, // Exclude the _id field from the result
//         },
//       },
//     ]);

//     console.log('Daily Aggregates:', aggregates);
//     return aggregates; // Return the calculated aggregates
//   } catch (error) {
//     console.error('Error calculating daily aggregates:', error);
//   }
// }

// Run the main function


main();
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));