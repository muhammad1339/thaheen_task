import 'package:flutter/material.dart';

import 'package:thaheen_task/l10n/app_localizations.dart';
import 'package:thaheen_task/core/design_system/thaheen_sizes.dart';
import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';

class ThaheenErrorStateView extends StatelessWidget {
  const ThaheenErrorStateView({this.message, this.onRetry, super.key});
  final String? message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: ThaheenSpacing.paddingLarge,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: ThaheenSizes.iconHero),
              ThaheenSpacing.gapVerticalMedium,
              Text(message ?? l.error, textAlign: TextAlign.center),
              if (onRetry != null) ...[
                ThaheenSpacing.gapVerticalMedium,
                FilledButton(onPressed: onRetry, child: Text(l.retry)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
