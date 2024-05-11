import 'package:flutter/material.dart';

class MyTab extends StatelessWidget {
  final String location;
  final String time;

  const MyTab({super.key, required this.location, required this.time});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(child: Text(location)),
        Center(child: Text(time)),
      ],
    ));
  }
}
