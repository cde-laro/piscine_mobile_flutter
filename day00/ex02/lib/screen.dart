import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  final dynamic _expression;
  final dynamic _result;

  const Screen(this._expression, this._result, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          readOnly: true,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            contentPadding: const EdgeInsets.all(8.0),
            hintText: _expression.toString(),
          ),
        ),
        TextField(
          readOnly: true,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            contentPadding: const EdgeInsets.all(8.0),
            hintText: _result.toString(),
          ),
        ),
      ],
    );
  }
}
