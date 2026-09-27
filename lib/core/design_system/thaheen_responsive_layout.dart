/// Breakpoints and responsive dimension calculations for layout adaptation.
abstract final class ThaheenResponsiveLayout {
  static const compactMaxWidth = 600.0;
  static const mediumMaxWidth = 840.0;
  static const maxContentWidth = 1200.0;
  static const maxReaderWidth = 960.0;

  static const minSidebarWidth = 320.0;
  static const maxSidebarWidth = 480.0;

  /// Calculates a fluid, proportional sidebar width clamped to safe bounds.
  static double dynamicSidebarWidth(double availableWidth) =>
      (availableWidth * 0.35).clamp(minSidebarWidth, maxSidebarWidth);

  /// Calculates the responsive column count for courses grid based on width.
  static int courseColumns(double availableWidth) {
    if (availableWidth < compactMaxWidth) return 1;
    if (availableWidth < mediumMaxWidth) return 2;
    if (availableWidth < maxContentWidth) return 3;
    return 4;
  }
}
