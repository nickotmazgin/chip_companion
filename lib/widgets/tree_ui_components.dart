import 'package:flutter/material.dart';

/// Enhanced card widget with tree background pattern
class TreeBackgroundCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showTrees;
  final double treeOpacity;

  const TreeBackgroundCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.showTrees = true,
    this.treeOpacity = 0.15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation ?? 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background with tree pattern (decorative - exclude from semantics)
            if (showTrees)
              Positioned.fill(
                child: ExcludeSemantics(
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.white,
                    ),
                    child: CustomPaint(
                      painter: CardTreePatternPainter(opacity: treeOpacity),
                    ),
                  ),
                ),
              ),
            if (!showTrees)
              Positioned.fill(
                child: Container(
                  color: backgroundColor ?? Colors.white,
                ),
              ),
            // Content
            Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
          ],
        ),
      ),
    );
  }
}

/// Tree pattern painter for cards with smaller, subtle trees
class CardTreePatternPainter extends CustomPainter {
  final double opacity;
  late final Paint _treePaint;

  CardTreePatternPainter({this.opacity = 0.15}) {
    // Memoize paint object to avoid recreation on every paint call
    _treePaint = Paint()
      ..color = const Color(0xFF2E7D32).withValues(alpha: opacity)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final treePaint = _treePaint;

    // Smaller spacing for cards
    final treeSpacing = 80.0;
    final treeSize = 0.6; // Scale factor for smaller trees

    for (double x = 20; x < size.width; x += treeSpacing) {
      for (double y = 20; y < size.height; y += treeSpacing) {
        final treeType = ((x + y) / treeSpacing).round() % 3;
        _drawSmallTree(canvas, Offset(x, y), treeType, treePaint, treeSize);
      }
    }
  }

  void _drawSmallTree(
    Canvas canvas,
    Offset position,
    int treeType,
    Paint paint,
    double scale,
  ) {
    final x = position.dx;
    final y = position.dy;
    final height = 30 * scale;

    switch (treeType) {
      case 0: // Small pine
        canvas.drawLine(
          Offset(x, y + height),
          Offset(x, y + height * 0.3),
          paint,
        );
        final path = Path();
        path.moveTo(x, y);
        path.lineTo(x - 8 * scale, y + height * 0.8);
        path.lineTo(x + 8 * scale, y + height * 0.8);
        path.close();
        canvas.drawPath(path, paint);
        break;
      case 1: // Small circle tree
        canvas.drawLine(
          Offset(x, y + height),
          Offset(x, y + height * 0.5),
          paint,
        );
        canvas.drawCircle(Offset(x, y + height * 0.4), 8 * scale, paint);
        break;
      case 2: // Small bushy tree
        canvas.drawLine(
          Offset(x, y + height),
          Offset(x, y + height * 0.6),
          paint,
        );
        canvas.drawCircle(
          Offset(x - 4 * scale, y + height * 0.4),
          6 * scale,
          paint,
        );
        canvas.drawCircle(
          Offset(x + 4 * scale, y + height * 0.4),
          6 * scale,
          paint,
        );
        canvas.drawCircle(Offset(x, y + height * 0.2), 7 * scale, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Enhanced AppBar with tree background
class TreeBackgroundAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double elevation;

  // Memoized gradient to avoid recreation
  static const _appBarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
  );

  const TreeBackgroundAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _appBarGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Tree pattern background (decorative - exclude from semantics)
          Positioned.fill(
            child: ExcludeSemantics(
              child: CustomPaint(painter: CardTreePatternPainter(opacity: 0.1)),
            ),
          ),
          // AppBar content
          AppBar(
            title: title,
            actions: actions,
            leading: leading,
            automaticallyImplyLeading: automaticallyImplyLeading,
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: const Color(0xFF2E7D32),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enhanced button with tree background
class TreeBackgroundButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const TreeBackgroundButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor?.withValues(alpha: 0.9) ??
                const Color(0xFFE8F5E8).withValues(alpha: 0.9),
            backgroundColor ?? const Color(0xFFF1F8E9),
            backgroundColor?.withValues(alpha: 0.9) ??
                const Color(0xFFE8F5E8).withValues(alpha: 0.9),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: elevation ?? 4,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: (backgroundColor ?? const Color(0xFF2E7D32)).withValues(
              alpha: 0.1,
            ),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Tree pattern background (decorative - exclude from semantics)
          Positioned.fill(
            child: ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CustomPaint(
                  painter: CardTreePatternPainter(opacity: 0.03),
                ),
              ),
            ),
          ),
          // Button content
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          color: textColor ?? const Color(0xFF1B5E20),
                          size: 22,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            color: textColor ?? const Color(0xFF1B5E20),
                            fontWeight: FontWeight.w800,
                            fontSize: 19,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
