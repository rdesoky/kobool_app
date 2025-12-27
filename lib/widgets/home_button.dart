import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  const HomeButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.height = 100,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, size: 32), Text(label)],
        ),
      ),
    );
  }
}
