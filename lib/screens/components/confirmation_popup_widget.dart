import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const ConfirmationDialog({
    required this.onCancel,
    required this.onSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: Colors.black,
      title: const Text(
        "Are you sure?",
        style: TextStyle(
          color: AppColors.mellowLemon,
          fontFamily: "Poppins",
        ),
      ),
      content: const Text(
        "Do you want to save your preferences?",
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'WorkSans',
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text(
            "CANCEL",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSans',
              fontSize: 16,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.royalPurple,
          ),
          onPressed: onSave,
          child: const Text(
            "SAVE",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSans',
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
