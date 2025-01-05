import "dart:ui";
import "package:flutter/material.dart";

class GlassContainer extends StatelessWidget {
  final double blur;
  final double opacity;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final Widget child;

  const GlassContainer({
    required this.blur,
    required this.opacity,
    required this.color,
    required this.borderRadius,
    required this.borderWidth,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(opacity * 4),
        Colors.white.withOpacity(opacity)
      ],
    );

    final borderGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Colors.white.withOpacity(opacity),
        Colors.white.withOpacity(opacity)
      ],
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: borderGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: borderWidth,
              color: Colors.white.withOpacity(opacity),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              decoration: BoxDecoration(
                gradient: backgroundGradient,
                color: color.withOpacity(opacity),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
