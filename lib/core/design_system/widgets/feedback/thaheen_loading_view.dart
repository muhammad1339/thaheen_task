import 'package:flutter/material.dart';

import 'package:thaheen_task/l10n/app_localizations.dart';

class ThaheenLoadingView extends StatelessWidget {
  const ThaheenLoadingView({super.key});
  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      semanticsLabel: AppLocalizations.of(context).loading,
    ),
  );
}
