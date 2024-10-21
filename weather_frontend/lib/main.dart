import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String selectedCity = 'London';
  Map<String, Map<String, dynamic>> dummyWeatherData = {
    'London': {
      'condition': 'Cloudy',
      'current_temp': 18,
      'feels_like': 17,
      'humidity': 75,
      'wind_speed': 12,
      'last_updated': '2024-10-21 14:30',
      'has_alert': false,
      'alert_message': '',
      'icon': Icons.cloud,
    },
    'New York': {
      'condition': 'Sunny',
      'current_temp': 25,
      'feels_like': 27,
      'humidity': 60,
      'wind_speed': 8,
      'last_updated': '2024-10-21 09:30',
      'has_alert': false,
      'alert_message': '',
      'icon': Icons.wb_sunny,
    },
    'Tokyo': {
      'condition': 'Rainy',
      'current_temp': 22,
      'feels_like': 23,
      'humidity': 85,
      'wind_speed': 15,
      'last_updated': '2024-10-21 22:30',
      'has_alert': true,
      'alert_message': 'Heavy rainfall expected',
      'icon': Icons.umbrella,
    },
    'Paris': {
      'condition': 'Partly Cloudy',
      'current_temp': 20,
      'feels_like': 19,
      'humidity': 70,
      'wind_speed': 10,
      'last_updated': '2024-10-21 15:30',
      'has_alert': false,
      'alert_message': '',
      'icon': Icons.cloud_queue,
    },
    'Sydney': {
      'condition': 'Clear',
      'current_temp': 28,
      'feels_like': 30,
      'humidity': 55,
      'wind_speed': 18,
      'last_updated': '2024-10-22 00:30',
      'has_alert': true,
      'alert_message': 'High UV index today',
      'icon': Icons.wb_sunny,
    },
  };

  List<String> cities = ['London', 'New York', 'Tokyo', 'Paris', 'Sydney'];

  @override
  Widget build(BuildContext context) {
    final weatherData = dummyWeatherData[selectedCity]!;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey, // Fallback color
          image: DecorationImage(
            image: NetworkImage('https://picsum.photos/1600/900?blur=2'),
            fit: BoxFit.cover,
            onError: (exception, stackTrace) {
              print('Error loading background image: $exception');
            },
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCity,
                    isExpanded: true,
                    dropdownColor: Colors.white.withOpacity(0.8),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCity = newValue!;
                      });
                    },
                    items: cities.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    underline: Container(),
                  ),
                ),  
              ),
              Expanded(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: weatherData['icon'] as IconData?,
                                  title: 'Condition',
                                  subtitle: weatherData['condition'] as String,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: Icons.thermostat,
                                  title: 'Temperature',
                                  subtitle: '${weatherData['current_temp']}°C',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: Icons.thermostat_auto,
                                  title: 'Feels Like',
                                  subtitle: '${weatherData['feels_like']}°C',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: Icons.water_drop,
                                  title: 'Humidity',
                                  subtitle: '${weatherData['humidity']}%',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: Icons.wind_power,
                                  title: 'Wind Speed',
                                  subtitle: '${weatherData['wind_speed']} km/h',
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: WeatherInfoTile(
                                  icon: Icons.update,
                                  title: 'Last Updated',
                                  subtitle:
                                      weatherData['last_updated'] as String,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          if (weatherData['has_alert'])
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      weatherData['alert_message'] as String,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;

  const WeatherInfoTile({
    Key? key,
    this.icon,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
