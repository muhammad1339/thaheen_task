import 'package:flutter/material.dart';

import 'package:thaheen_task/l10n/app_localizations.dart';

/// Asks what to do when progress could not be saved before leaving.
///
/// Returns true to leave: either the user chose "leave" anyway, or [retry]
/// succeeded. Returns false to stay.
Future<bool> showUnsavedProgressDialog(
  BuildContext context, {
  required Future<bool> Function() retry,
}) async {
  final l = AppLocalizations.of(context);
  final leave = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l.unsavedProgress),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l.leave),
        ),
        FilledButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            if (await retry()) navigator.pop(true);
          },
          child: Text(l.retry),
        ),
      ],
    ),
  );
  return leave ?? false;
}
