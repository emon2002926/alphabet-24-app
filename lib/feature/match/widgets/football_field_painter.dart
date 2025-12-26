import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class FootballFieldPainter extends CustomPainter {
  final Color fieldColor;
  final Color lineColor;
  final Color grassStripeColor;
  final double lineWidth;
  final bool showStripes;

  FootballFieldPainter({
    this.fieldColor = const Color(0xFF2D7A3E),
    this.lineColor = Colors.white,
    this.grassStripeColor = const Color(0xFF258535),
    this.lineWidth = 2.0,
    this.showStripes = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    // Draw grass stripes background
    if (showStripes) {
      _drawGrassStripes(canvas, size, paint);
    } else {
      // Solid field color
      paint.color = fieldColor;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }

    // Draw field lines
    _drawFieldLines(canvas, size, linePaint);

    // Draw center circle
    _drawCenterCircle(canvas, size, linePaint);

    // Draw penalty areas
    _drawPenaltyAreas(canvas, size, linePaint);

    // Draw goal areas
    _drawGoalAreas(canvas, size, linePaint);

    // Draw penalty spots
    _drawPenaltySpots(canvas, size, linePaint);

    // Draw corner arcs
    _drawCornerArcs(canvas, size, linePaint);
  }

  void _drawGrassStripes(Canvas canvas, Size size, Paint paint) {
    const stripeCount = 10;
    final stripeHeight = size.height / stripeCount;

    for (int i = 0; i < stripeCount; i++) {
      paint.color = i % 2 == 0 ? fieldColor : grassStripeColor;
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        paint,
      );
    }
  }

  void _drawFieldLines(Canvas canvas, Size size, Paint linePaint) {
    // Outer boundary
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      linePaint,
    );

    // Center line (horizontal)
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );
  }

  void _drawCenterCircle(Canvas canvas, Size size, Paint linePaint) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.15; // 15% of field width

    // Center circle
    canvas.drawCircle(
      Offset(centerX, centerY),
      radius,
      linePaint,
    );

    // Center spot
    final spotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(centerX, centerY),
      lineWidth * 1.5,
      spotPaint,
    );
  }

  void _drawPenaltyAreas(Canvas canvas, Size size, Paint linePaint) {
    final penaltyAreaWidth = size.width * 0.6; // 60% of field width
    final penaltyAreaHeight = size.height * 0.18; // 18% of field height
    final penaltyAreaX = (size.width - penaltyAreaWidth) / 2;

    // Top penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        penaltyAreaX,
        0,
        penaltyAreaWidth,
        penaltyAreaHeight,
      ),
      linePaint,
    );

    // Bottom penalty area
    canvas.drawRect(
      Rect.fromLTWH(
        penaltyAreaX,
        size.height - penaltyAreaHeight,
        penaltyAreaWidth,
        penaltyAreaHeight,
      ),
      linePaint,
    );

    // Penalty arcs
    _drawPenaltyArcs(canvas, size, linePaint, penaltyAreaHeight);
  }

  void _drawPenaltyArcs(Canvas canvas, Size size, Paint linePaint, double penaltyAreaHeight) {
    final centerX = size.width / 2;
    final arcRadius = size.width * 0.12;
    final penaltySpotDistance = size.height * 0.12;

    // Top penalty arc
    final topArcRect = Rect.fromCircle(
      center: Offset(centerX, penaltySpotDistance),
      radius: arcRadius,
    );
    canvas.drawArc(
      topArcRect,
      0.9, // Start angle (radians)
      1.34, // Sweep angle (radians)
      false,
      linePaint,
    );

    // Bottom penalty arc
    final bottomArcRect = Rect.fromCircle(
      center: Offset(centerX, size.height - penaltySpotDistance),
      radius: arcRadius,
    );
    canvas.drawArc(
      bottomArcRect,
      -2.24, // Start angle (radians)
      1.34, // Sweep angle (radians)
      false,
      linePaint,
    );
  }

  void _drawGoalAreas(Canvas canvas, Size size, Paint linePaint) {
    final goalAreaWidth = size.width * 0.35; // 35% of field width
    final goalAreaHeight = size.height * 0.08; // 8% of field height
    final goalAreaX = (size.width - goalAreaWidth) / 2;

    // Top goal area
    canvas.drawRect(
      Rect.fromLTWH(
        goalAreaX,
        0,
        goalAreaWidth,
        goalAreaHeight,
      ),
      linePaint,
    );

    // Bottom goal area
    canvas.drawRect(
      Rect.fromLTWH(
        goalAreaX,
        size.height - goalAreaHeight,
        goalAreaWidth,
        goalAreaHeight,
      ),
      linePaint,
    );
  }

  void _drawPenaltySpots(Canvas canvas, Size size, Paint linePaint) {
    final centerX = size.width / 2;
    final penaltySpotDistance = size.height * 0.12; // 12% from top/bottom

    final spotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    // Top penalty spot
    canvas.drawCircle(
      Offset(centerX, penaltySpotDistance),
      lineWidth * 1.5,
      spotPaint,
    );

    // Bottom penalty spot
    canvas.drawCircle(
      Offset(centerX, size.height - penaltySpotDistance),
      lineWidth * 1.5,
      spotPaint,
    );
  }

  void _drawCornerArcs(Canvas canvas, Size size, Paint linePaint) {
    final arcRadius = size.width * 0.04; // 4% of field width

    // Top-left corner
    canvas.drawArc(
      Rect.fromLTWH(0 - arcRadius, 0 - arcRadius, arcRadius * 2, arcRadius * 2),
      0,
      1.57, // 90 degrees in radians
      false,
      linePaint,
    );

    // Top-right corner
    canvas.drawArc(
      Rect.fromLTWH(size.width - arcRadius, 0 - arcRadius, arcRadius * 2, arcRadius * 2),
      1.57,
      1.57,
      false,
      linePaint,
    );

    // Bottom-left corner
    canvas.drawArc(
      Rect.fromLTWH(0 - arcRadius, size.height - arcRadius, arcRadius * 2, arcRadius * 2),
      4.71,
      1.57,
      false,
      linePaint,
    );

    // Bottom-right corner
    canvas.drawArc(
      Rect.fromLTWH(size.width - arcRadius, size.height - arcRadius, arcRadius * 2, arcRadius * 2),
      3.14,
      1.57,
      false,
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant FootballFieldPainter oldDelegate) {
    return oldDelegate.fieldColor != fieldColor ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.grassStripeColor != grassStripeColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.showStripes != showStripes;
  }
}

// Theme-aware widget that automatically adapts to light/dark mode
class FootballField extends StatelessWidget {
  final double width;
  final double height;
  final Color? fieldColor;
  final Color? lineColor;
  final Color? grassStripeColor;
  final double lineWidth;
  final bool showStripes;

  const FootballField({
    Key? key,
    required this.width,
    required this.height,
    this.fieldColor,
    this.lineColor,
    this.grassStripeColor,
    this.lineWidth = 2.0,
    this.showStripes = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Auto-detect theme and set appropriate colors
    final Color effectiveFieldColor = fieldColor ??
        (isDarkMode
            ? const Color(0xFF1A1A1A)  // Dark mode: Dark gray/black field
            : const Color(0xFF2D7A3E)); // Light mode: Green field

    final Color effectiveLineColor = lineColor ??
        (isDarkMode
            ? Colors.white  // Dark mode: White lines
            : Colors.white); // Light mode: White lines

    final Color effectiveStripeColor = grassStripeColor ??
        (isDarkMode
            ? const Color(0xFF2A2A2A)  // Dark mode: Slightly lighter gray
            : const Color(0xFF258535)); // Light mode: Lighter green

    return CustomPaint(
      size: Size(width, height),
      painter: FootballFieldPainter(
        fieldColor: effectiveFieldColor,
        lineColor: effectiveLineColor,
        grassStripeColor: effectiveStripeColor,
        lineWidth: lineWidth,
        showStripes: showStripes,
      ),
    );
  }
}

// Extension methods for easy theme-based field creation
extension FootballFieldThemes on FootballField {
  // Classic green field (light mode default)
  static FootballField classic({
    required double width,
    required double height,
  }) {
    return FootballField(
      width: width,
      height: height,
      fieldColor: const Color(0xFF2D7A3E),
      lineColor: Colors.white,
      grassStripeColor: const Color(0xFF258535),
      showStripes: true,
    );
  }

  // Dark theme field
  static FootballField dark({
    required double width,
    required double height,
  }) {
    return FootballField(
      width: width,
      height: height,
      fieldColor: const Color(0xFF1A1A1A),
      lineColor: Colors.white,
      grassStripeColor: const Color(0xFF2A2A2A),
      showStripes: true,
    );
  }

  // Light/minimal theme field
  static FootballField light({
    required double width,
    required double height,
  }) {
    return FootballField(
      width: width,
      height: height,
      fieldColor: const Color(0xFFF5F5F5),
      lineColor: const Color(0xFF2D7A3E),
      grassStripeColor: const Color(0xFFEEEEEE),
      showStripes: true,
    );
  }
}




// USAGE EXAMPLES FOR FOOTBALL FIELD CUSTOMIZATION

// 1. DEFAULT FIELD (Green with white lines and stripes)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// )
//
// // 2. CLASSIC GREEN FIELD
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF2D7A3E),      // Dark green
// lineColor: Colors.white,
// grassStripeColor: const Color(0xFF258535), // Light green stripes
// lineWidth: 2.0,
// showStripes: true,
// )
//
// // 3. SOLID GREEN (No stripes)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF1B5E20),
// lineColor: Colors.white,
// showStripes: false,
// )
//
// // 4. INDOOR FIELD (Blue/Green synthetic)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF00796B),      // Teal
// lineColor: Colors.white,
// grassStripeColor: const Color(0xFF26A69A),
// lineWidth: 2.5,
// showStripes: true,
// )
//
// // 5. NIGHT MODE FIELD (Dark theme)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF1A1A1A),      // Dark gray
// lineColor: const Color(0xFF00E676),       // Bright green lines
// grassStripeColor: const Color(0xFF2A2A2A),
// lineWidth: 2.0,
// showStripes: true,
// )
//
// // 6. RETRO FIELD (Brown/Yellow)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF8D6E63),      // Brown
// lineColor: Colors.white,
// grassStripeColor: const Color(0xFFA1887F),
// lineWidth: 2.0,
// showStripes: true,
// )
//
// // 7. MINIMAL FIELD (Light background)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFFF1F8F4),      // Very light green
// lineColor: const Color(0xFF2D7A3E),       // Dark green lines
// grassStripeColor: const Color(0xFFE8F5E9),
// lineWidth: 1.5,
// showStripes: true,
// )
//
// // 8. BOLD LINES (Thicker lines for better visibility)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF2D7A3E),
// lineColor: Colors.white,
// grassStripeColor: const Color(0xFF258535),
// lineWidth: 3.5, // Thicker lines
// showStripes: true,
// )
//
// // 9. CUSTOM BRAND COLORS (Example: Blue theme)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF1565C0),      // Blue
// lineColor: Colors.white,
// grassStripeColor: const Color(0xFF1976D2), // Lighter blue
// lineWidth: 2.0,
// showStripes: true,
// )
//
// // 10. PREMIUM FIELD (Rich green with golden lines)
// FootballField(
// width: constraints.maxWidth,
// height: constraints.maxHeight,
// fieldColor: const Color(0xFF1B5E20),
// lineColor: const Color(0xFFFFD700),       // Gold lines
// grassStripeColor: const Color(0xFF2E7D32),
// lineWidth: 2.5,
// showStripes: true,
// )
//
// // FIELD FEATURES INCLUDED:
// // ✅ Outer boundary
// // ✅ Center line
// // ✅ Center circle with center spot
// // ✅ Penalty areas (both ends)
// // ✅ Penalty arcs (D-shaped)
// // ✅ Goal areas (6-yard box)
// // ✅ Penalty spots
// // ✅ Corner arcs
// // ✅ Grass stripes (optional)
// // ✅ Customizable colors
// // ✅ Adjustable line width