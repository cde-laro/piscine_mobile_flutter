import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'package:intl/intl.dart';

class Today extends StatelessWidget {
  final WeatherData? weatherData;

  const Today({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return weatherData?.hourlyWeather != null
        ? Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Text('Time')),
                    Expanded(child: Text('Temperature')),
                    Expanded(child: Text('Description')),
                    Expanded(child: Text('Wind Speed')),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: weatherData!.hourlyWeather.length,
                  itemBuilder: (context, index) {
                    final meteo = weatherData!.hourlyWeather[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Text(DateFormat.Hm()
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
