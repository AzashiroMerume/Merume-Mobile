import 'package:flutter/material.dart';

class MessageBubble extends CustomPainter {
  final Color bgColor;
  final bool direction;

  MessageBubble(this.bgColor, {this.direction = true});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();

    if (direction) {
      path.lineTo(12.5, 0); // Move right to make wider
      path.lineTo(0, 15); // Increase height
      path.lineTo(0, 0); // Move left to make wider
    } else {
      path.lineTo(-12.5, 0); // Move left to make wider
      path.lineTo(0, 15); // Increase height
      path.lineTo(0, 0); // Move right to make wider
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
