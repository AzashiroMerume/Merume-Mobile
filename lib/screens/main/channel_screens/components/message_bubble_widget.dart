import 'package:flutter/material.dart';

class MessageBubble extends CustomPainter {
  final Color bgColor;

  MessageBubble(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-10, 0); // Move left to make wider
    path.lineTo(0, 15); // Increase height
    path.lineTo(10, 0); // Move right to make wider
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
