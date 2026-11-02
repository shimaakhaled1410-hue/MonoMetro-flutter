import 'package:flutter/material.dart';
import 'package:metro/core/utils/theme_extensions.dart';

class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final Widget label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(icon, size: 18, color: context.brand),
        label: label,
        onPressed: onPressed,
      ),
    );
  }
}
