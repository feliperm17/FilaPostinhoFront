import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;

  const BackgroundGradient({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[900]!,
                  Colors.grey[850]!,
                  Colors.grey[800]!,
                ]
              : [
                  Colors.blue[50]!,
                  Colors.white,
                  Colors.blue[50]!,
                ],
        ),
      ),
      child: child,
    );
  }
}
