import 'package:flutter/material.dart';
import 'screen.dart';
import 'keyboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ex02',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _expression = '0';
  int _result = 0;

  void _incrementCounter() {
    setState(() {
      _result++;
    });
  }

  void _onKeyPressed(String key) {
    debugPrint('Button Pressed: $key');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Center(child: Text('Calculator')),
      ),
      body: Column(children: [
        Screen(_expression, _result),
        Expanded(child: Keyboard(onKeyPressed: _onKeyPressed)),
      ]),
    );
  }
}
