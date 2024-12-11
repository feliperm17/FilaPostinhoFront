import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

class ThemeToggleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isDark;

  const ThemeToggleButton({
    super.key,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
      child: IconButton(
        key: ValueKey<bool>(isDark),
        icon: Icon(
          isDark ? Icons.wb_sunny : Icons.nightlight_round,
          color: AppColors.primary,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
