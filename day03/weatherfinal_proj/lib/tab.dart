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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('Loading')),
        ],
      ));
    } else if (time == 'Currently') {
      return Currently(
          weatherData:
              weatherData); // Return Currently widget if time is 'currently'
    } else if (time == 'Today') {
      return Today(
          weatherData:
              weatherData); // Return Currently widget if time is 'currently'
    } else if (time == 'Weekly') {
      return Weekly(
          weatherData:
              weatherData); // Return Currently widget if time is 'currently'
    } else {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text(weatherData?.location.toString() ?? 'Loading...')),
          Center(child: Text(time)),
        ],
      ));
    }
  }
}
