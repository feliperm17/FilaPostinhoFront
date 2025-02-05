import 'package:flutter/material.dart';
import 'package:fila_postinho_front/core/constants/responsive_breakpoints.dart';

class AdaptiveFormField extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  const AdaptiveFormField({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen =
            constraints.maxWidth < ResponsiveBreakpoints.tabletBreakpoint;

        if (isSmallScreen) {
          return Column(
            crossAxisAlignment: crossAxisAlignment,
            children: children
                .expand((child) => [
                      child,
                      SizedBox(height: spacing),
                    ])
                .toList()
              ..removeLast(),
          );
        }

        return Row(
          crossAxisAlignment: crossAxisAlignment,
          children: children
              .expand((child) => [
                    Expanded(child: child),
                    SizedBox(width: spacing),
                  ])
              .toList()
            ..removeLast(),
        );
      },
    );
  }
}
