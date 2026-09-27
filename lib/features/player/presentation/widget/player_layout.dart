import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_responsive_layout.dart';
import 'package:thaheen_task/core/design_system/widgets/layout/thaheen_centered_content.dart';

/// Places the [video] and the lesson [info] side by side on wide screens and
/// stacked on narrow ones.
///
/// Give both children a `GlobalKey` so their state (the video controller, the
/// notes draft) survives a resize that switches between the two layouts.
class PlayerLayout extends StatelessWidget {
  const PlayerLayout({required this.video, required this.info, super.key});

  final Widget video;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return ThaheenCenteredContent(
      maxWidth: ThaheenResponsiveLayout.maxContentWidth,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return width >= ThaheenResponsiveLayout.mediumMaxWidth
              ? _SideBySidePlayerLayout(
                  sidebarWidth: ThaheenResponsiveLayout.dynamicSidebarWidth(
                    width,
                  ),
                  video: video,
                  info: info,
                )
              : _StackedPlayerLayout(video: video, info: info);
        },
      ),
    );
  }
}

class _SideBySidePlayerLayout extends StatelessWidget {
  const _SideBySidePlayerLayout({
    required this.sidebarWidth,
    required this.video,
    required this.info,
  });

  final double sidebarWidth;
  final Widget video;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThaheenSpacing.paddingMedium,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SingleChildScrollView(child: video)),
          ThaheenSpacing.gapHorizontalMedium,
          SizedBox(
            width: sidebarWidth,
            child: SingleChildScrollView(child: info),
          ),
        ],
      ),
    );
  }
}

class _StackedPlayerLayout extends StatelessWidget {
  const _StackedPlayerLayout({required this.video, required this.info});

  final Widget video;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: ThaheenSpacing.paddingMedium,
      child: Column(children: [video, ThaheenSpacing.gapVerticalLarge, info]),
    );
  }
}
