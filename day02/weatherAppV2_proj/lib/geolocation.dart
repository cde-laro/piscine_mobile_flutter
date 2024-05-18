import 'dart:convert';
import 'meteo.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class City {
  final String name;
  final String admin;
  final String country;
  final LocationData locationData;

  City({
    required this.name,
    required this.admin,
    required this.country,
    required this.locationData,
  });

  @override
  String toString() {
    return '$name - $admin - $country';
  }
}

Future<City?> getLocation() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return null;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  locationData = await location.getLocation();
  City city = await getCityByLocation(locationData);
  getCurrentMeteo(city);
  getHourlyMeteo(city);
  getWeekMeteo(city);

  return city;
}

Future<City> getCityByLocation(LocationData location) async {
  var url =
      'https://geo.api.gouv.fr/communes?lat=${location.latitude.toString()}&lon=${location.longitude.toString()}&fields=nom,region';
  var response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var city = City(
      name: data[0]['nom'],
      admin: data[0]['region']['nom'],
      country: 'France',
      locationData: location,
    );
    return city;
  } else {
    var city = City(
      name: "Unknown",
      admin: "Unknown",
      country: "Unknown",
      locationData: location,
    );
    return city;
  }
}
