import 'package:flutter/material.dart';
import 'geolocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TextBox extends StatefulWidget {
  final Function(WeatherData?) setWeatherData;
  final Function(CityResult?) getWeatherDataBySearch;

  const TextBox(
      {super.key,
      required this.setWeatherData,
      required this.getWeatherDataBySearch});

  @override
  TextBoxState get createState => TextBoxState();
}

class CityResult {
  final String name;
  final String admin1;
  final String country;
  final double longitude;
  final double latitude;

  CityResult({
    required this.name,
    required this.admin1,
    required this.country,
    required this.longitude,
    required this.latitude,
  });

  @override
  String toString() {
    return '$name - $admin1 - $country';
  }
}

class TextBoxState extends State<TextBox> {
  Future<List<CityResult>> _getOptions(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=10&language=fr&format=json'));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        if (map['results'] == null) {
          return [];
        }
        List<dynamic> list = map['results'];
        return list
            .map((item) => CityResult(
                  name: item['name'] ?? '',
                  admin1: item['admin1'] ?? '',
                  country: item['country'] ?? '',
                  longitude: item['longitude'] ?? 0.0,
                  latitude: item['latitude'] ?? 0.0,
                ))
            .toList();
      } else {
        throw Exception('Failed to load options');
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          const Icon(Icons.search),
          Flexible(
            child: Autocomplete<CityResult>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<CityResult>.empty();
                }
                return _getOptions(textEditingValue.text);
              },
              onSelected: (CityResult selection) {
                widget.getWeatherDataBySearch(selection);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.near_me),
            onPressed: () => getWeatherData().then((weatherData) {
              if (weatherData != null) {
                widget.setWeatherData(weatherData);
              }
            }),
          )
        ],
      ),
    );
  }
}
