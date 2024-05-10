import 'package:flutter/material.dart';
import 'dart:math';

class Keyboard extends StatelessWidget {
  final Function(String) onKeyPressed;

  const Keyboard({required this.onKeyPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final keyboardHeight = constraints.maxHeight;
        final screenWidth = MediaQuery.of(context).size.width;
        final buttonHeight = keyboardHeight / 4;
        final aspectRatio = max(1, screenWidth / (buttonHeight * 5));
        final keyboardAspectRatio =
            max(5 / 4, screenWidth / (buttonHeight * 4));

        return Column(children: <Widget>[
          Expanded(child: Container()),
          AspectRatio(
            aspectRatio: keyboardAspectRatio.toDouble(),
            child: GridView.count(
              crossAxisCount: 5,
              childAspectRatio: aspectRatio.toDouble(),
              children: <Widget>[
                ...[
                  '7',
                  '8',
                  '9',
                  'C',
                  'AC',
                  '4',
                  '5',
                  '6',
                  '+',
                  '-',
                  '1',
                  '2',
                  '3',
                  '*',
                  '/',
                  '0',
                  '.',
                  '00',
                  '=',
                  ' '
                ].map(
                  (key) {
                    return SizedBox(
                      height: aspectRatio
                          .toDouble(), // Set the height of the button
                      child: ElevatedButton(
                        onPressed: () => onKeyPressed(key),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          side: MaterialStateProperty.all(
                              const BorderSide(color: Colors.grey, width: 1)),
                        ),
                        child: Text(key),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ]);
      },
    );
  }
}
