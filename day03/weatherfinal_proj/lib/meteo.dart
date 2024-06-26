import 'geolocation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherDescription {
  static Map<String, dynamic>? _cachedDescriptions;

  static Future<String> getIcon(int weatherCode) async {
    if (_cachedDescriptions == null) {
      var url = Uri.parse(
        'https://gist.githubusercontent.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c/raw/76b0cb0ef0bfd8a2ec988aa54e30ecd1b483495d/descriptions.json',
      );
      var response = await http.get(url);
      if (response.statusCode == 200) {
        _cachedDescriptions = jsonDecode(response.body);
      } else {
        return 'https://cdn-icons-png.flaticon.com/512/5266/5266579.png';
      }
    }
    return _cachedDescriptions![weatherCode.toString()]['day']['image'] ??
        'https://cdn-icons-png.flaticon.com/512/5266/5266579.png';
  }

  static Future<String> getDescription(int weatherCode) async {
    if (_cachedDescriptions == null) {
      var url = Uri.parse(
        'https://gist.githubusercontent.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c/raw/76b0cb0ef0bfd8a2ec988aa54e30ecd1b483495d/descriptions.json',
      );
      var response = await http.get(url);
      if (response.statusCode == 200) {
        _cachedDescriptions = jsonDecode(response.body);
      } else {
        return 'IDK SRY :/';
      }
    }
    return _cachedDescriptions![weatherCode.toString()]['day']['description'] ??
        'IDK SRY :/';
  }
}

class Meteo {
  final String temperature;
  final String description;
  final String windSpeed;
  final String icon;
  final String time;

  Meteo({
    required this.temperature,
    required this.description,
    this.icon = '01d',
    required this.windSpeed,
    required this.time,
  });

  @override
  String toString() {
    return 'Temperature: $temperature\nDescription: $description\nWind speed: $windSpeed';
  }
}

Future<Meteo> getCurrentMeteo(City city) async {
  var url = Uri.https(
    'api.open-meteo.com',
    '/v1/forecast',
    {
      'latitude': city.locationData.latitude.toString(),
      'longitude': city.locationData.longitude.toString(),
      "current": ["temperature_2m", "weather_code", "wind_speed_10m"],
      "timezone": "Europe/Berlin",
    },
  );
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var meteo = Meteo(
      time: 'Now',
      temperature:
          '${data['current']['temperature_2m'].toString()} ${data['current_units']['temperature_2m']}',
      description: await WeatherDescription.getDescription(
          data['current']['weather_code']),
      icon: await WeatherDescription.getIcon(data['current']['weather_code']),
      windSpeed:
          '${data['current']['wind_speed_10m'].toString()} ${data['current_units']['wind_speed_10m']}',
    );
    return meteo;
  } else {
    return Meteo(
      temperature: 'No data',
      description: 'No data',
      windSpeed: 'No data',
      time: 'No data',
    );
  }
}

Future<List<Meteo>> getHourlyMeteo(City city) async {
  var url = Uri.https(
    'api.open-meteo.com',
    '/v1/forecast',
    {
      'latitude': city.locationData.latitude.toString(),
      'longitude': city.locationData.longitude.toString(),
      "hourly": ["temperature_2m", "weather_code", "wind_speed_10m"],
      "timezone": "Europe/Berlin",
      "forecast_days": "1"
    },
  );
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var hourlyData = data['hourly']['time'];
    var hourlyTemperature = data['hourly']['temperature_2m'];
    var hourlyWeatherCode = data['hourly']['weather_code'];
    var hourlyWindSpeed = data['hourly']['wind_speed_10m'];
    var meteos = <Meteo>[];
    for (var index = 0; index < hourlyData.length; index++) {
      var meteo = Meteo(
        temperature:
            '${hourlyTemperature[index].toString()} ${data['hourly_units']['temperature_2m']}',
        description:
            await WeatherDescription.getDescription(hourlyWeatherCode[index]),
        icon: await WeatherDescription.getIcon(hourlyWeatherCode[index]),
        windSpeed:
            '${hourlyWindSpeed[index].toString()} ${data['hourly_units']['wind_speed_10m']}',
        time: hourlyData[index].toString(),
      );
      meteos.add(meteo);
    }
    return meteos;
  } else {
    throw Exception('Failed to load meteo');
  }
}

Future<List<Meteo>> getWeekMeteo(City city) async {
  var url = Uri.https(
    'api.open-meteo.com',
    '/v1/forecast',
    {
      'latitude': city.locationData.latitude.toString(),
      'longitude': city.locationData.longitude.toString(),
      "daily": [
        "weather_code",
        "temperature_2m_max",
        "temperature_2m_min",
        "wind_speed_10m_max"
      ],
      "timezone": "Europe/Berlin",
    },
  );
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var dailyData = data['daily']['time'];
    var dailyTemperatureMax = data['daily']['temperature_2m_max'];
    var dailyTemperatureMin = data['daily']['temperature_2m_min'];
    var dailyWeatherCode = data['daily']['weather_code'];
    var dailyWindSpeed = data['daily']['wind_speed_10m_max'];
    var meteos = <Meteo>[];
    for (var index = 0; index < dailyData.length; index++) {
      var meteo = Meteo(
        temperature:
            '${dailyTemperatureMin[index].toString()} - ${dailyTemperatureMax[index].toString()} ${data['daily_units']['temperature_2m_min']}',
        description:
            await WeatherDescription.getDescription(dailyWeatherCode[index]),
        icon: await WeatherDescription.getIcon(dailyWeatherCode[index]),
        windSpeed:
            '${dailyWindSpeed[index].toString()} ${data['daily_units']['wind_speed_10m_max']}',
        time: dailyData[index].toString(),
      );
      meteos.add(meteo);
    }
    return meteos;
  } else {
    throw Exception('Failed to load meteo');
  }
}
