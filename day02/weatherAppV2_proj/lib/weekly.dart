import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'package:intl/intl.dart';

class Weekly extends StatelessWidget {
  final WeatherData? weatherData;

  const Weekly({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return weatherData?.weeklyWeather != null
        ? Column(
            children: [
              Text(weatherData?.location.toString() ?? 'Loading...'),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Text('Date')),
                    Expanded(child: Text('Temperature')),
                    Expanded(child: Text('Description')),
                    Expanded(child: Text('Wind Speed')),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: weatherData!.weeklyWeather.length,
                  itemBuilder: (context, index) {
                    final meteo = weatherData!.weeklyWeather[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text(DateFormat('dd/MM')
                                  .format(DateTime.parse(meteo.time)))),
                          Expanded(child: Text(meteo.temperature)),
                          Expanded(child: Text(meteo.description)),
                          Expanded(child: Text(meteo.windSpeed)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          )
        : const Center(child: Text('Loading weather data...'));
  }
}
