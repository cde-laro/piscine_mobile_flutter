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
        Text(
          weatherData?.location.name.toString() ?? 'Loading...',
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 26.0,
          ),
        ),
        Text(
          '${weatherData?.location.admin} - ${weatherData?.location.country}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        if (weatherData?.currentWeather != null) ...[
          Text(
            weatherData!.currentWeather.temperature,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 24.0,
            ),
          ),
          Text(
            weatherData!.currentWeather.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            width: 150.0,
            height: 150.0,
            child: Image.network(
              weatherData!.currentWeather.icon,
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                Icons.air,
                color: Colors.blueAccent,
              ),
              Text(
                ' ${weatherData!.currentWeather.windSpeed}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                ),
              ),
            ],
          )
        ] else ...[
          const Text('Loading weather data...'),
        ],
      ],
    ));
  }
}
