import 'package:flutter/material.dart';

import 'package:thaheen_task/l10n/app_localizations.dart';

/// Inline "not saved" message with a retry button, for a save that failed
/// while the rest of the screen keeps working.
class ThaheenRetryNotice extends StatelessWidget {
  const ThaheenRetryNotice({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.notSaved),
        TextButton(onPressed: onRetry, child: Text(l.retry)),
      ],
    );
  }
}
