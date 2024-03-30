import 'package:flutter/material.dart';

Widget buildImage(String? imageUrl, String noImageCase,
    {height = 60.0, width = 60.0}) {
  return imageUrl != null
      ? Image.network(
          imageUrl,
          height: height,
          width: width,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              noImageCase,
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          },
        )
      : Image.asset(
          noImageCase,
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
}
