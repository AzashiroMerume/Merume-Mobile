import 'package:flutter/material.dart';

class NetworkErrorPopupWidget extends StatelessWidget {
  const NetworkErrorPopupWidget({super.key, this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 150,
            child: Image.asset('assets/images/no_connection.png'),
          ),
          const SizedBox(height: 16),
          const Text(
            "Whoops!",
            style: TextStyle(
                fontSize: 20,
                fontFamily: "WorkSans",
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "No internet connection found.",
            style: TextStyle(
                fontSize: 14,
                fontFamily: "WorkSans",
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Check your connection and try again.",
            style: TextStyle(fontSize: 12, fontFamily: "WorkSans"),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                // Add any specific button styling here
                ),
            child: const Text(
              "Try Again",
              style: TextStyle(fontFamily: "WorkSans"),
            ),
          )
        ],
      ),
    );
  }
}
