import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';

void main() {
  runApp(
    MaterialApp(
      home: DefaultTextStyle(
        style: TextStyle(
          decoration: TextDecoration.none,
        ),
        child: const StartScreen(),
      ),
    ),
  );
}
