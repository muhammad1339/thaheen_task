import 'package:flutter/material.dart';

/// Pins [child] to the top center and caps its width, so wide screens get a
/// readable column instead of edge-to-edge content.
class ThaheenCenteredContent extends StatelessWidget {
  const ThaheenCenteredContent({
    required this.maxWidth,
    required this.child,
    super.key,
  });

  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
