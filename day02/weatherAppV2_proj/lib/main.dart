import 'package:flutter/material.dart';

import 'tab.dart';
import 'geolocation.dart';

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
  State<MyHomePage> createState() => _MyHomePageState();
}

class TextBox extends StatelessWidget {
  final Function(City?) setLocation;
  const TextBox({super.key, required this.setLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.search),
            const Flexible(
              child: TextField(
                // onSubmitted: (value) => setLocation(value),
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Search'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.near_me),
              onPressed: () => getLocation().then((city) {
                if (city != null) {
                  setLocation(city);
                }
              }),
            )
          ],
        ));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  City? _location;
  @override
  initState() {
    super.initState();
    getLocation().then((city) {
      if (city != null) {
        setState(() {
          _location = city;
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
              setLocation: (location) => setState(() {
                _location = location;
              }),
            ),
          ),
          body: ValueListenableBuilder(
            valueListenable: ValueNotifier<City?>(_location),
            builder: (context, value, child) {
              return TabBarView(
                children: <Widget>[
                  Center(child: MyTab(location: value, time: 'Currently')),
                  Center(child: MyTab(location: value, time: 'Today')),
                  Center(child: MyTab(location: value, time: 'Weekly')),
                ],
              );
            },
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
