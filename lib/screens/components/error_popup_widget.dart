import 'package:flutter/material.dart';
import 'package:merume_mobile/colors.dart';

class ErrorPopupWidget extends StatelessWidget {
  final String errorMessage;

  const ErrorPopupWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Error',
          style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
      content: Text(
        errorMessage,
        style: const TextStyle(
            color: Colors.white, fontFamily: 'WorkSans', fontSize: 14),
      ),
      backgroundColor: Colors.red, // Dark background color
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.royalPurple, // Custom button color
          ),
          child: const Text('OK', style: TextStyle(color: Colors.white)),
        ),
      ],
      shape: const RoundedRectangleBorder(
        side: BorderSide(
            color: Colors.redAccent,
            width: 2.0), // Custom border color and width
        borderRadius:
            BorderRadius.all(Radius.circular(8.0)), // Custom border radius
      ),
    );
  }
}
