import 'dart:math';

import 'package:flutter/material.dart';
import '../extensions.dart';

//1
class ProfileCardPainter extends CustomPainter {
  //2
  ProfileCardPainter({@required this.color, @required this.avatarRadius});

  //3
  final Color color;
  final double avatarRadius;

  //4
  @override
  void paint(Canvas canvas, Size size) {
    //1
    final shapeBounds =
        Rect.fromLTWH(0, 0, size.width, size.height - avatarRadius);
    //2
    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds =
        Rect.fromCircle(center: centerAvatar, radius: avatarRadius).inflate(6);
    _drawBackground(canvas, shapeBounds, avatarBounds);

    final curveShapeBounds = Rect.fromLTRB(
        shapeBounds.left,
        shapeBounds.top + shapeBounds.height * 0.35,
        shapeBounds.right,
        shapeBounds.bottom);

    _drawCurvedShape(canvas, curveShapeBounds, avatarBounds);
  }

  //5
  @override
  bool shouldRepaint(ProfileCardPainter oldDelegate) {
    return color != oldDelegate.color;
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect avatarBounds) {
    final paint = Paint()..color = color;

    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top)
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..arcTo(avatarBounds, -pi, pi, false)
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..close();

    canvas.drawPath(backgroundPath, paint);
  }

  void _drawCurvedShape(Canvas canvas, Rect bounds, Rect avatarBounds) {
    final colors = [color.darker(), color, color.darker()];
    final stops = [0.0,0.3,1.0];
    final gradient = LinearGradient(colors: colors, stops: stops);
    final paint = Paint()..shader = gradient.createShader(bounds);
    final handlePoint = Offset(bounds.left + (bounds.width * 0.25), bounds.top);

    final curvePath = Path()
      ..moveTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarBounds, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..quadraticBezierTo(handlePoint.dx, handlePoint.dy, bounds.bottomLeft.dx,
          bounds.bottomLeft.dy)
      ..close();

    canvas.drawPath(curvePath, paint);
  }
}
