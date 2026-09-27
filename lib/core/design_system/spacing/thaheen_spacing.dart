import 'package:flutter/widgets.dart';

/// Design tokens for standardized spacing, paddings, and insets.
abstract final class ThaheenSpacing {
  static const small = 8.0;
  static const mediumSmall = 12.0;
  static const medium = 16.0;
  static const large = 24.0;

  // Standard insets
  static const paddingMedium = EdgeInsets.all(medium);
  static const paddingLarge = EdgeInsets.all(large);

  /// Inner padding of course cards: roomier than [medium], tighter than [large].
  static const paddingCard = EdgeInsets.all(20);

  // Vertical gaps
  static const gapVerticalSmall = SizedBox(height: small);
  static const gapVerticalMediumSmall = SizedBox(height: mediumSmall);
  static const gapVerticalMedium = SizedBox(height: medium);
  static const gapVerticalLarge = SizedBox(height: large);

  // Horizontal gaps
  static const gapHorizontalMedium = SizedBox(width: medium);
}
