import 'package:flutter/material.dart';
import 'package:merume_mobile/other/colors.dart';
import 'package:smart_snackbars/enums/animate_from.dart';
import 'package:smart_snackbars/smart_snackbars.dart';

void showCustomSnackBar(BuildContext context, {String message = ''}) {
  SmartSnackBars.showCustomSnackBar(
    context: context,
    duration: const Duration(seconds: 5),
    animationCurve: Curves.fastLinearToSlowEaseIn,
    animateFrom: AnimateFrom.fromTop,
    child: Container(
      color: AppColors.postMain,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  message,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'WorkSans',
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    ),
  );
}
