import 'package:flutter/material.dart';
import 'package:merume_mobile/screens/on_boarding/start_screen.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: const StartScreen(),
    ));
