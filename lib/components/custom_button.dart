import "package:flutter/material.dart";

class CustomButton extends StatelessWidget {
  final String text;
  final EdgeInsets padding;
  final double borderRadius;
  final Color color;
  final double fontSize;
  final String fontFamily;
  final Color textColor;
  final VoidCallback onTap;

  const CustomButton({
    required this.text,
    required this.padding,
    required this.borderRadius,
    required this.color,
    required this.fontSize,
    required this.fontFamily,
    required this.textColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 2,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: padding.horizontal, vertical: padding.vertical),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
