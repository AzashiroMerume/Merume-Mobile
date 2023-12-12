import 'package:flutter/material.dart';

void showCustomSnackBar(BuildContext context, String errorMessage,
    {int duration = 10}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      content: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            errorMessage,
            style: const TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 15,
              color: Colors.white,
            ),
          ),
        ),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.red,
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    ),
  );
}
