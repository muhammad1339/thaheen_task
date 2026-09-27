import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';

class ThaheenEmptyStateView extends StatelessWidget {
  const ThaheenEmptyStateView({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: ThaheenSpacing.paddingLarge,
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}
