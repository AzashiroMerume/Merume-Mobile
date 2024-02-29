import 'package:flutter/material.dart';
import 'package:merume_mobile/utils/colors.dart';
import 'package:merume_mobile/screens/shared/basic/basic_elevated_button_widget.dart';

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
          side: const BorderSide(width: 0.5, color: AppColors.lavenderHaze)),
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
        BasicElevatedButtonWidget(
          buttonText: 'SAVE',
          onPressed: onSave,
          width: 100,
          height: 35,
        ),
      ],
    );
  }
}
