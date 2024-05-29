import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'package:intl/intl.dart';
import 'today_graph.dart';

class Today extends StatelessWidget {
  final WeatherData? weatherData;

  const Today({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return weatherData?.hourlyWeather != null
        ? Column(
            children: [
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
              TemperatureChart(meteos: weatherData!.hourlyWeather),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherData!.hourlyWeather.length,
                  itemBuilder: (context, index) {
                    final meteo = weatherData!.hourlyWeather[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            DateFormat.Hm().format(DateTime.parse(meteo.time)),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Image.network(
                              meteo.icon,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            meteo.temperature,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 18.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Icon(
                                Icons.air,
                                size: 15,
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
                          ),
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
