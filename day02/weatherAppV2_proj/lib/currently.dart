import 'package:flutter/material.dart';
import 'geolocation.dart';

class Currently extends StatelessWidget {
  final WeatherData? weatherData;

  const Currently({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(weatherData?.location.toString() ?? 'Loading...'),
        if (weatherData?.currentWeather != null) ...[
          Text('Temperature: ${weatherData!.currentWeather.temperature}'),
          Text('Description: ${weatherData!.currentWeather.description}'),
          Text('Wind Speed: ${weatherData!.currentWeather.windSpeed}'),
          // Add more Text widgets for other properties of currentWeather
        ] else ...[
          const Text('Loading weather data...'),
        ],
      ],
    ));
  }
}
