import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'package:intl/intl.dart';
import 'weekly_graph.dart';

class Weekly extends StatelessWidget {
  final WeatherData? weatherData;

  const Weekly({super.key, required this.weatherData});

  List<double> extractTemperatures(String tempString) {
    List<String> parts = tempString.split(' - ');
    double temp1 = double.parse(parts[0]);
    double temp2 = double.parse(parts[1].split('°')[0]);
    return [temp1, temp2];
  }

  @override
  Widget build(BuildContext context) {
    return weatherData?.weeklyWeather != null
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
              WeeklyTemperatureChart(meteos: weatherData!.weeklyWeather),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherData!.weeklyWeather.length,
                  itemBuilder: (context, index) {
                    final meteo = weatherData!.weeklyWeather[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('dd/MM')
                                .format(DateTime.parse(meteo.time)),
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
                            '${extractTemperatures(meteo.temperature)[1].toString()}°C',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            '${extractTemperatures(meteo.temperature)[0].toString()}°C',
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 14.0,
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
        : const Center(child: CircularProgressIndicator());
  }
}
