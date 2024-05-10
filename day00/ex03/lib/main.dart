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
      title: 'ex03',
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
  String _expression = "0";
  double _result = 0.0;

  bool isDigit(String char) {
    int charCode = char.codeUnitAt(0);
    return charCode >= 48 && charCode <= 57;
  }

  void removeSpaces(List<Map<String, dynamic>> operations) {
    for (var operation in operations) {
      operation['operation'] = operation['operation'].replaceAll(' ', '');
    }
  }

  bool isOnlyDigitString(String s) {
    try {
      double.parse(s);
      return true;
    } catch (e) {
      return false;
    }
  }

  bool hasMinusNotPrecededByOperator(String s) {
    for (int i = 1; i < s.length; i++) {
      if (s[i] == '-' &&
          (s[i - 1] != '+' &&
              s[i - 1] != '-' &&
              s[i - 1] != '*' &&
              s[i - 1] != '/')) {
        return true;
      }
    }
    return false;
  }

  String getLastOperator(String string) {
    String operator = '';
    for (int i = 0; i < string.length; i++) {
      if (string[i] == '*' || string[i] == '/') {
        operator = string[i];
      }
    }
    return operator;
  }

  double _getResult(string) {
    double result = 0.0;
    if (string.contains('+')) {
      List<String> parts = string.split('+');

      parts.asMap().forEach((i, element) {
        if (isOnlyDigitString(element)) {
          if (i == 0) {
            result = double.parse(element);
          } else {
            result += double.parse(element);
          }
        } else {
          if (i == 0) {
            result = _getResult(element);
          } else {
            result += _getResult(element);
          }
        }
      });
    } else if (string.contains('-') &&
        !isOnlyDigitString(string) &&
        hasMinusNotPrecededByOperator(string)) {
      List<String> parts = [''];
      for (int i = 0; i < string.length; i++) {
        if (string[i] == '-' && i > 0 && isDigit(string[i - 1])) {
          parts.add('');
        } else {
          parts[parts.length - 1] += string[i];
        }
      }

      parts.removeWhere((element) => element == '');
      parts.asMap().forEach((i, element) {
        if (isOnlyDigitString(element)) {
          if (i == 0) {
            result = double.parse(element);
          } else {
            result -= double.parse(element);
          }
        } else {
          if (i == 0) {
            result = _getResult(element);
          } else {
            result -= _getResult(element);
          }
        }
      });
    } else if (isOnlyDigitString(string)) {
      result = double.parse(string);
    } else {
      String operator = getLastOperator(string);
      if (operator == '/') {
        List<String> parts = string.split('/');

        parts.removeWhere((element) => element.isEmpty);
        parts.asMap().forEach((i, element) {
          if (isOnlyDigitString(element)) {
            if (i == 0) {
              result = double.parse(element);
            } else {
              result /= double.parse(element);
            }
          } else {
            if (i == 0) {
              result = _getResult(element);
            } else {
              result /= _getResult(element);
            }
          }
        });
      } else if ((operator == '*')) {
        List<String> parts = string.split('*');

        parts.removeWhere((element) => element.isEmpty);

        parts.asMap().forEach((i, element) {
          if (isOnlyDigitString(element)) {
            if (i == 0) {
              result = double.parse(element);
            } else {
              result *= double.parse(element);
            }
          } else {
            if (i == 0) {
              result = _getResult(element);
            } else {
              result *= _getResult(element);
            }
          }
        });
      }
    }
    return result;
  }

  void _onKeyPressed(String key) {
    if (key == 'AC') {
      setState(() {
        _expression = '';
        _result = 0.0;
      });
    } else if (key == 'C') {
      setState(() {
        _expression = _expression.substring(0, _expression.length - 1);
      });
    } else if (isDigit(key) || key == '00') {
      setState(() {
        _expression += key;
      });
    } else if (key == '+' || key == '*' || key == '/') {
      if (_expression.isNotEmpty &&
          isDigit(_expression[_expression.length - 1])) {
        setState(() {
          _expression += key;
        });
      }
    } else if (key == '-') {
      if (_expression.isEmpty || _expression[_expression.length - 1] != '-') {
        setState(() {
          _expression += key;
        });
      }
    } else if (key == '.') {
      if (_expression.isEmpty ||
          !isDigit(_expression[_expression.length - 1])) {
        setState(() {
          _expression += '0.';
        });
      } else if (_expression[_expression.length - 1] != '.') {
        setState(() {
          _expression += '.';
        });
      }
    } else if (key == '=') {
      setState(() {
        _result = _getResult(_expression);
      });
    }
    return;
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
