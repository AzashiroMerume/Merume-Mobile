import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';

class BasicElevatedButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const BasicElevatedButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.isPressed,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 178, height ?? 38),
        backgroundColor: backgroundColor ?? AppColors.royalPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: isPressed ? AppColors.royalPurple : Colors.transparent,
          ),
        ),
      ),
      child: isPressed
          ? const SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                color: AppColors.lavenderHaze,
              ),
            )
          : Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.w500,
              ),
            ),
    );
  }
}
