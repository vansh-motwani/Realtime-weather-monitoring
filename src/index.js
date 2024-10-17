// src/index.js
const { getWeather } = require("./services/weatherService");
const WeatherData = require('./models/WeatherData'); // Import the WeatherData model

//const dailyWeatherData = []; // Store weather data for daily aggregation

async function collectWeatherData(city) {
  try {
    const weatherData = await getWeather(city);
    const currentTemp = weatherData.main.temp;

    const newWeatherData = new WeatherData({
      date: new Date().toISOString().split("T")[0],
      timestamp: new Date().toISOString(),
      temperature: currentTemp,
      condition: weatherData.weather[0].description,
    });

    // Save to MongoDB
    await newWeatherData.save();
    // Push the collected weather data to our dailyWeatherData array

    console.log(`Weather data saved for ${city}:`, newWeatherData);
  } catch (error) {
    console.error("Error in collectWeatherData:", error);
  }
}

async function main() {
  const city = "Delhi"; // Change this city as needed

  // Fetch initial weather data
  await collectWeatherData(city);

  // Set interval to collect weather data every 5 minutes
  setInterval(async () => {
    await collectWeatherData(city);
    await calculateDailyAggregates();
  }, 5000); // 5 minutes in milliseconds

  // You can call a function to calculate aggregates whenever needed
}

async function calculateDailyAggregates() {
  try {
    const aggregates = await WeatherData.aggregate([
      {
        $group: {
          _id: { $dateToString: { format: "%Y-%m-%d", date: "$timestamp" } }, // Group by date
          maxTemp: { $max: "$temperature" },
          minTemp: { $min: "$temperature" },
          totalTemp: { $sum: "$temperature" },
          count: { $sum: 1 },
          dominantCondition: { $first: "$condition" }, // This can be enhanced for better logic
        },
      },
      {
        $project: {
          date: "$_id", // Rename the field
          averageTemp: { $divide: ["$totalTemp", "$count"] }, // Calculate average
          maxTemp: 1,
          minTemp: 1,
          dominantCondition: 1,
          _id: 0, // Exclude the _id field from the result
        },
      },
    ]);

    console.log('Daily Aggregates:', aggregates);
    return aggregates; // Return the calculated aggregates
  } catch (error) {
    console.error('Error calculating daily aggregates:', error);
  }
}

// Run the main function
main();
