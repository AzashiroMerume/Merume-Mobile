import 'package:flutter/material.dart';
import 'package:merume_mobile/constants/colors.dart';

class BasicElevatedButtonWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  final bool? isPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;

  const BasicElevatedButtonWidget({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isPressed,
    this.width,
    this.height,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (isPressed == true)
          ? null
          : onPressed, // Disable onPressed if isPressed is true
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? 178, height ?? 38),
        backgroundColor: backgroundColor ?? AppColors.royalPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: (isPressed == null || isPressed == true)
                ? AppColors.royalPurple
                : Colors.transparent,
          ),
        ),
      ),
      child: (isPressed == null || isPressed == false)
          ? Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSans',
                fontWeight: FontWeight.w500,
              ),
            )
          : const SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                color: AppColors.lavenderHaze,
              ),
            ),
    );
  }
}
