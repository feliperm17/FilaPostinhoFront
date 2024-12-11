import 'package:flutter/material.dart';
import 'package:fila_postinho_front/core/constants/responsive_breakpoints.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final bool centerContent;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isSmallScreen =
            screenWidth < ResponsiveBreakpoints.tabletBreakpoint;

        return SingleChildScrollView(
          padding: padding ??
              EdgeInsets.all(isSmallScreen
                  ? ResponsiveBreakpoints.paddingSmall
                  : ResponsiveBreakpoints.paddingLarge),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? ResponsiveBreakpoints.maxContentWidth,
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
