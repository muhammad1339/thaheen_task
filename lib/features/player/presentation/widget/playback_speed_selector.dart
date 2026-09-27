import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_retry_notice.dart';
import 'package:thaheen_task/core/design_system/widgets/inputs/thaheen_choice_chips.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Speed chips, plus a retry when the chosen speed failed to save to settings.
class PlaybackSpeedSelector extends StatelessWidget {
  const PlaybackSpeedSelector({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final double selected;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final saveFailed = context.select<AppSettingsCubit, bool>(
      (settings) => settings.state.failure != null,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThaheenChoiceChips<double>(
          label: l.speed,
          options: {
            for (final speed in AppSettingsEntity.speeds)
              speed: l.speedLabel(speed.toString()),
          },
          selected: selected,
          onSelected: onSelected,
        ),
        if (saveFailed)
          ThaheenRetryNotice(
            onRetry: context.read<AppSettingsCubit>().retrySave,
          ),
      ],
    );
  }
}
