import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/theme/thaheen_colors.dart';
import 'package:thaheen_task/core/design_system/thaheen_radius.dart';
import 'package:thaheen_task/core/design_system/thaheen_sizes.dart';

/// Central theme builder configuring color schemes, component themes, and radii.
abstract final class ThaheenTheme {
  static const _primarySeed = Color(0xff176b61);
  static const _scaffoldLight = Color(0xfff5f7f4);
  static const _scaffoldDark = Color(0xff111b19);
  static const _colors = ThaheenColors(
    videoBackground: Color(0xff000000),
    videoOverlayScrim: Color(0x8a000000),
    videoOverlayText: Color(0xffffffff),
  );

  /// Prebuilt themes; `ColorScheme.fromSeed` is too costly to redo per build.
  static final light = build(Brightness.light);
  static final dark = build(Brightness.dark);

  static ThemeData build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _primarySeed,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: const [_colors],
      scaffoldBackgroundColor: brightness == Brightness.light
          ? _scaffoldLight
          : _scaffoldDark,
      appBarTheme: const AppBarTheme(centerTitle: false),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: ThaheenRadius.controlBorderRadius,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            ThaheenSizes.minTouchTarget,
            ThaheenSizes.minTouchTarget,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            ThaheenSizes.minTouchTarget,
            ThaheenSizes.minTouchTarget,
          ),
        ),
      ),
    );
  }
}
