import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final int? errorCode;

  const ErrorScreen({super.key, this.errorCode});

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (errorCode) {
      case 1:
        errorMessage =
            'The service connection is lost, please check your internet connection or try again later';
        break;
      case 2:
        errorMessage = 'Could not find any results for the specified location';
        break;
      case 3:
        errorMessage =
            'Geolocation is not available, please enable it in your settings';
        break;
      default:
        errorMessage = 'An unknown error occurred';
    }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: errorMessage,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
