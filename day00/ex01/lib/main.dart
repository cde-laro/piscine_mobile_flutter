import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex01',
      theme: ThemeData(useMaterial3: true ),
      home: const MyHomePage(title: 'ex01: Say Hello to the World'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _displayText = "Don't Panic!" ;

  void _changeText() {
    setState(() {
      _displayText = _displayText == "Don't Panic!" ? 'Hello World' : "Don't Panic!";
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_displayText),
            ElevatedButton(
              onPressed: () { _changeText(); },
              child: const Text('Panic'),
            ),
          ],
        ),
      ),
    );
  }  
}

