import 'package:flutter/material.dart';

/// Semantic colors accessed through `Theme.of(context).extension<ThaheenColors>()`.
@immutable
class ThaheenColors extends ThemeExtension<ThaheenColors> {
  const ThaheenColors({
    required this.videoBackground,
    required this.videoOverlayScrim,
    required this.videoOverlayText,
  });

  final Color videoBackground;
  final Color videoOverlayScrim;
  final Color videoOverlayText;

  @override
  ThaheenColors copyWith({
    Color? videoBackground,
    Color? videoOverlayScrim,
    Color? videoOverlayText,
  }) => ThaheenColors(
    videoBackground: videoBackground ?? this.videoBackground,
    videoOverlayScrim: videoOverlayScrim ?? this.videoOverlayScrim,
    videoOverlayText: videoOverlayText ?? this.videoOverlayText,
  );

  @override
  ThaheenColors lerp(covariant ThaheenColors? other, double t) {
    if (other == null) return this;
    return ThaheenColors(
      videoBackground: Color.lerp(videoBackground, other.videoBackground, t)!,
      videoOverlayScrim: Color.lerp(
        videoOverlayScrim,
        other.videoOverlayScrim,
        t,
      )!,
      videoOverlayText: Color.lerp(
        videoOverlayText,
        other.videoOverlayText,
        t,
      )!,
    );
  }
}
