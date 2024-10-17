// src/utils/temperatureConverter.js

function kelvinToCelsius(kelvin) {
    return kelvin - 273.15; // Convert Kelvin to Celsius
  }
  
  function celsiusToFahrenheit(celsius) {
    return (celsius * 9) / 5 + 32; // Convert Celsius to Fahrenheit
  }
  
  module.exports = { kelvinToCelsius, celsiusToFahrenheit };
  