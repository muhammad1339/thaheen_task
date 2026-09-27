import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/widget/settings_sheet.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// App-bar action that opens the [SettingsSheet].
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: AppLocalizations.of(context).settings,
      icon: const Icon(Icons.tune),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (_) => BlocProvider.value(
          value: context.read<AppSettingsCubit>(),
          child: const SettingsSheet(),
        ),
      ),
    );
  }
}
