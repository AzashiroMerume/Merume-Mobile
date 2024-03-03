import 'package:flutter/material.dart';
import 'package:merume_mobile/utils/colors.dart';

class TextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 24.0,
    fontFamily: 'Franklin-Gothic-Medium',
  );

  static const TextStyle headline = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    color: Colors.black,
    fontFamily: 'WorkSans',
  );

  static const TextStyle errorBig = TextStyle(
    fontSize: 18.0,
    color: AppColors.lightGrey,
    fontFamily: 'WorkSans',
  );

  static const TextStyle errorSmall = TextStyle(
    fontSize: 15.0,
    color: AppColors.mellowLemon,
    fontFamily: 'WorkSans',
  );

  static const TextStyle subtle = TextStyle(
    fontSize: 14.0,
    color: Colors.white,
    fontFamily: 'WorkSans',
  );
}
