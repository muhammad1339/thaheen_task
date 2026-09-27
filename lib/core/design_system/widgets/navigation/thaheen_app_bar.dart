import 'package:flutter/material.dart';

/// Shared app bar styled by the active theme's [AppBarTheme].
///
/// Screens supply their title and actions. Flutter handles automatic back
/// navigation and RTL unless a screen supplies its own leading widget.
class ThaheenAppBar extends AppBar {
  ThaheenAppBar({
    super.key,
    super.title,
    super.leading,
    super.actions,
    super.automaticallyImplyLeading,
  });
}
