import 'dart:ui';

import 'package:flutter/material.dart';
import 'error.dart';
import 'tab.dart';
import 'geolocation.dart';
import 'textbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  WeatherData? _weatherData;
  int errorCode = 0;

  @override
  initState() {
    super.initState();
    getWeatherData().then((weatherData) {
      if (weatherData != null) {
        setState(() {
          _weatherData = weatherData;
          errorCode = 0;
        });
      } else {
        setState(() {
          errorCode = 3;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: TextBox(
              setWeatherData: (weatherData) => setState(() {
                _weatherData = weatherData;
              }),
              getWeatherDataBySearch: (cityResult) async {
                if (cityResult != null) {
                  var weatherData = await getWeatherDataBySearch(cityResult);
                  setState(() {
                    _weatherData = weatherData;
                    errorCode = 0;
                  });
                } else {
                  setState(() {
                    errorCode = 2;
                  });
                }
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1.5,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                    child: errorCode != 0
                        ? ErrorScreen(errorCode: errorCode)
                        : ValueListenableBuilder(
                            valueListenable:
                                ValueNotifier<WeatherData?>(_weatherData),
                            builder: (context, value, child) {
                              return TabBarView(
                                children: <Widget>[
                                  Center(
                                      child: MyTab(
                                          weatherData: value,
                                          time: 'Currently')),
                                  Center(
                                      child: MyTab(
                                          weatherData: value, time: 'Today')),
                                  Center(
                                      child: MyTab(
                                          weatherData: value, time: 'Weekly')),
                                ],
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomAppBar(
            child: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.lightbulb), text: 'Currently'),
                Tab(icon: Icon(Icons.today), text: 'Today'),
                Tab(icon: Icon(Icons.view_week), text: 'Weekly'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
