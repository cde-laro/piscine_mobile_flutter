import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'currently.dart';
import 'today.dart';
import 'weekly.dart';

class MyTab extends StatelessWidget {
  final WeatherData? weatherData;
  final String time;

  const MyTab({super.key, required this.weatherData, required this.time});

  @override
  Widget build(BuildContext context) {
    if (weatherData == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (time == 'Currently') {
      return SingleChildScrollView(
        child: Currently(weatherData: weatherData),
      );
    } else if (time == 'Today') {
      return SingleChildScrollView(
        child: Today(weatherData: weatherData),
      );
    } else if (time == 'Weekly') {
      return SingleChildScrollView(
        child: Weekly(weatherData: weatherData),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weatherData?.location.toString() ?? 'Loading...'),
            Text(time),
          ],
        ),
      );
    }
  }
}
