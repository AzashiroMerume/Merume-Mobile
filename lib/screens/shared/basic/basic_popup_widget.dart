import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';
import 'package:merume_mobile/constants/text_styles.dart';

class BasicPopup extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onCancel;

  const BasicPopup({
    required this.title,
    this.subtitle,
    this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(width: 0.5, color: AppColors.lavenderHaze)),
      backgroundColor: Colors.black,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.mellowLemon,
          fontFamily: "Poppins",
        ),
      ),
      content: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyles.body,
            )
          : null,
      actions: onCancel != null
          ? [
              TextButton(
                onPressed: onCancel,
                child: const Text(
                  "CANCEL",
                  style: TextStyles.body,
                ),
              ),
            ]
          : null,
    );
  }
}
