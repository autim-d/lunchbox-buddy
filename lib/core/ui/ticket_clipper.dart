import 'package:flutter/material.dart';

/// CustomClipper that clips a widget into a classic lunch ticket shape
/// with rounded corners and semicircular perforated punch-notches on both sides.
class PerforatedTicketClipper extends CustomClipper<Path> {
  const PerforatedTicketClipper({
    this.borderRadius = 16.0,
    this.notchRadius = 12.0,
    this.notchY = 88.0,
    this.notchYRatio,
  });

  final double borderRadius;
  final double notchRadius;
  final double notchY;
  final double? notchYRatio;

  @override
  Path getClip(Size size) {
    final path = Path();
    final effectiveNotchY = notchYRatio != null
        ? size.height * notchYRatio!
        : notchY;

    // Top-left starting point after top-left corner
    path.moveTo(borderRadius, 0);

    // Top edge
    path.lineTo(size.width - borderRadius, 0);
    // Top-right corner
    path.arcToPoint(
      Offset(size.width, borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Right edge down to notch
    path.lineTo(size.width, effectiveNotchY - notchRadius);
    // Right semicircular notch (inward into the ticket)
    path.arcToPoint(
      Offset(size.width, effectiveNotchY + notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Right edge down to bottom-right corner
    path.lineTo(size.width, size.height - borderRadius);
    // Bottom-right corner
    path.arcToPoint(
      Offset(size.width - borderRadius, size.height),
      radius: Radius.circular(borderRadius),
    );

    // Bottom edge
    path.lineTo(borderRadius, size.height);
    // Bottom-left corner
    path.arcToPoint(
      Offset(0, size.height - borderRadius),
      radius: Radius.circular(borderRadius),
    );

    // Left edge up to notch
    path.lineTo(0, effectiveNotchY + notchRadius);
    // Left semicircular notch (inward into the ticket)
    path.arcToPoint(
      Offset(0, effectiveNotchY - notchRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    // Left edge up to top-left corner
    path.lineTo(0, borderRadius);
    // Top-left corner
    path.arcToPoint(
      Offset(borderRadius, 0),
      radius: Radius.circular(borderRadius),
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant PerforatedTicketClipper oldClipper) {
    return oldClipper.borderRadius != borderRadius ||
        oldClipper.notchRadius != notchRadius ||
        oldClipper.notchY != notchY ||
        oldClipper.notchYRatio != notchYRatio;
  }
}

/// CustomPainter to draw a perforated dashed stitch line between the ticket notches
class DashedSeparatorPainter extends CustomPainter {
  const DashedSeparatorPainter({
    required this.color,
    this.dashWidth = 6.0,
    this.dashSpace = 4.0,
    this.strokeWidth = 1.5,
  });

  final Color color;
  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0.0;
    final y = size.height / 2;

    while (startX < size.width) {
      final endX = (startX + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedSeparatorPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashSpace != dashSpace ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
