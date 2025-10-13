import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

class TreeBackground extends StatelessWidget {
  final Widget child;
  final bool showTrees;
  final bool debugMode;

  const TreeBackground({
    super.key,
    required this.child,
    this.showTrees = true,
    this.debugMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showTrees) {
      return child;
    }

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE8F5E8), // Very light green
            Color(0xFFF1F8E9), // Light green
            Color(0xFFEFEBD8), // Warm wood tone
            Color(0xFFE8F5E8), // Very light green
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Tree pattern background
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: TreePatternPainter(debugMode: debugMode),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            ),
          ),
          // Content
          child,
        ],
      ),
    );
  }
}

class TreePatternPainter extends CustomPainter {
  final bool debugMode;

  TreePatternPainter({this.debugMode = false});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw various tree patterns across the canvas
    _drawTrees(canvas, size);
  }

  void _drawTrees(Canvas canvas, Size size) {
    final treeSpacing = 120.0; // Increased spacing for better text readability
    final treeVariations = 5;

    // Web-specific optimizations
    final isWeb = kIsWeb;
    final baseOpacity = debugMode
        ? 0.9
        : (isWeb ? 0.7 : 0.5); // Much higher opacity for visibility
    final strokeWidth = debugMode
        ? 6.0
        : (isWeb ? 5.0 : 4.0); // Much thicker for web

    // Add subtle wood grain background pattern
    _drawWoodGrainPattern(canvas, size, baseOpacity * 0.3);

    // Draw trees with varied opacity for depth
    for (double x = 0; x < size.width + treeSpacing; x += treeSpacing) {
      for (double y = 0; y < size.height + treeSpacing; y += treeSpacing) {
        final treeType = ((x + y) / treeSpacing).round() % treeVariations;
        final depth = (x + y) % 3; // Create depth layers
        final depthOpacity =
            baseOpacity * (0.7 + (depth * 0.15)); // Vary opacity for depth
        final finalOpacity = depthOpacity + (treeType * 0.05);

        final treePaint = Paint()
          ..color = const Color(0xFF2E7D32).withValues(alpha: finalOpacity)
          ..strokeWidth = strokeWidth + (treeType * 0.3) + (depth * 0.2)
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true;

        _drawTree(canvas, Offset(x, y), treeType, treePaint);

        // Add occasional forest floor elements
        if ((x + y) % 300 == 0) {
          _drawForestFloorElement(canvas, Offset(x + 20, y + 85), treePaint);
        }
      }
    }
  }

  void _drawTree(Canvas canvas, Offset position, int treeType, Paint paint) {
    final x = position.dx;
    final y = position.dy;

    switch (treeType) {
      case 0: // Pine Tree
        _drawPineTree(canvas, x, y, paint);
        break;
      case 1: // Oak Tree
        _drawOakTree(canvas, x, y, paint);
        break;
      case 2: // Spruce Tree
        _drawSpruceTree(canvas, x, y, paint);
        break;
      case 3: // Willow Tree
        _drawWillowTree(canvas, x, y, paint);
        break;
      case 4: // Palm Tree
        _drawPalmTree(canvas, x, y, paint);
        break;
    }
  }

  void _drawPineTree(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    // Trunk
    path.moveTo(x, y + 80);
    path.lineTo(x, y + 60);
    // Lower branches
    path.moveTo(x, y + 60);
    path.lineTo(x - 15, y + 60);
    path.lineTo(x, y + 40);
    path.lineTo(x + 15, y + 60);
    path.lineTo(x, y + 60);
    // Middle branches
    path.moveTo(x, y + 60);
    path.lineTo(x - 12, y + 60);
    path.lineTo(x, y + 35);
    path.lineTo(x + 12, y + 60);
    path.lineTo(x, y + 60);
    // Upper branches
    path.moveTo(x, y + 60);
    path.lineTo(x - 8, y + 60);
    path.lineTo(x, y + 25);
    path.lineTo(x + 8, y + 60);
    path.lineTo(x, y + 60);
    // Top
    path.moveTo(x, y + 60);
    path.lineTo(x - 5, y + 60);
    path.lineTo(x, y + 15);
    path.lineTo(x + 5, y + 60);
    path.lineTo(x, y + 60);
    canvas.drawPath(path, paint);
  }

  void _drawOakTree(Canvas canvas, double x, double y, Paint paint) {
    // Trunk
    canvas.drawLine(Offset(x, y + 80), Offset(x, y + 50), paint);
    // Crown - multiple overlapping circles for a fuller look
    canvas.drawCircle(Offset(x, y + 45), 20, paint);
    canvas.drawCircle(Offset(x - 8, y + 40), 15, paint);
    canvas.drawCircle(Offset(x + 8, y + 40), 15, paint);
    canvas.drawCircle(Offset(x, y + 30), 12, paint);
    canvas.drawCircle(Offset(x - 5, y + 25), 8, paint);
    canvas.drawCircle(Offset(x + 5, y + 25), 8, paint);
  }

  void _drawSpruceTree(Canvas canvas, double x, double y, Paint paint) {
    final path = Path();
    // Trunk
    path.moveTo(x, y + 80);
    path.lineTo(x, y + 60);
    // Lower tier
    path.moveTo(x, y + 60);
    path.lineTo(x - 12, y + 60);
    path.lineTo(x, y + 45);
    path.lineTo(x + 12, y + 60);
    path.lineTo(x, y + 60);
    // Middle tier
    path.moveTo(x, y + 60);
    path.lineTo(x - 10, y + 60);
    path.lineTo(x, y + 40);
    path.lineTo(x + 10, y + 60);
    path.lineTo(x, y + 60);
    // Upper tier
    path.moveTo(x, y + 60);
    path.lineTo(x - 8, y + 60);
    path.lineTo(x, y + 30);
    path.lineTo(x + 8, y + 60);
    path.lineTo(x, y + 60);
    // Top tier
    path.moveTo(x, y + 60);
    path.lineTo(x - 6, y + 60);
    path.lineTo(x, y + 20);
    path.lineTo(x + 6, y + 60);
    path.lineTo(x, y + 60);
    canvas.drawPath(path, paint);
  }

  void _drawWillowTree(Canvas canvas, double x, double y, Paint paint) {
    // Trunk
    canvas.drawLine(Offset(x, y + 80), Offset(x, y + 50), paint);
    // Drooping branches - multiple layers
    final path = Path();
    // Main canopy
    path.moveTo(x, y + 50);
    path.quadraticBezierTo(x - 20, y + 45, x - 20, y + 25);
    path.quadraticBezierTo(x - 20, y + 5, x, y + 15);
    path.quadraticBezierTo(x + 20, y + 5, x + 20, y + 25);
    path.quadraticBezierTo(x + 20, y + 45, x, y + 50);
    // Additional drooping branches
    path.moveTo(x - 10, y + 45);
    path.quadraticBezierTo(x - 15, y + 40, x - 15, y + 20);
    path.moveTo(x + 10, y + 45);
    path.quadraticBezierTo(x + 15, y + 40, x + 15, y + 20);
    canvas.drawPath(path, paint);
  }

  void _drawPalmTree(Canvas canvas, double x, double y, Paint paint) {
    // Trunk
    canvas.drawLine(Offset(x, y + 80), Offset(x, y + 50), paint);
    // Palm fronds - more detailed
    final path = Path();
    // Main fronds
    path.moveTo(x, y + 50);
    path.lineTo(x - 15, y + 25);
    path.moveTo(x, y + 50);
    path.lineTo(x + 15, y + 25);
    path.moveTo(x, y + 50);
    path.lineTo(x - 8, y + 30);
    path.moveTo(x, y + 50);
    path.lineTo(x + 8, y + 30);
    // Additional fronds
    path.moveTo(x, y + 50);
    path.lineTo(x - 12, y + 20);
    path.moveTo(x, y + 50);
    path.lineTo(x + 12, y + 20);
    path.moveTo(x, y + 50);
    path.lineTo(x - 5, y + 35);
    path.moveTo(x, y + 50);
    path.lineTo(x + 5, y + 35);
    canvas.drawPath(path, paint);
  }

  void _drawWoodGrainPattern(Canvas canvas, Size size, double opacity) {
    final grainPaint = Paint()
      ..color = const Color(0xFF8D6E63)
          .withValues(alpha: opacity) // Brown wood color
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Draw subtle horizontal wood grain lines
    for (double y = 0; y < size.height; y += 40) {
      final path = Path();
      path.moveTo(0, y);
      // Create wavy wood grain lines
      for (double x = 0; x < size.width; x += 20) {
        final waveY = y + (sin(x * 0.01) * 2);
        path.lineTo(x, waveY);
      }
      canvas.drawPath(path, grainPaint);
    }
  }

  void _drawForestFloorElement(Canvas canvas, Offset position, Paint paint) {
    final x = position.dx;
    final y = position.dy;

    // Draw small forest floor elements (mushrooms, logs, bushes)
    final floorPaint = Paint()
      ..color = paint.color.withValues(alpha: paint.color.a * 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Draw a small bush or log
    canvas.drawOval(
      Rect.fromCenter(center: Offset(x, y), width: 15, height: 6),
      floorPaint,
    );

    // Add some texture lines
    canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), floorPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
