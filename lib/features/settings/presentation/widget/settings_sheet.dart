import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_responsive_layout.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_retry_notice.dart';
import 'package:thaheen_task/core/design_system/widgets/inputs/thaheen_choice_chips.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Bottom sheet for language and theme. Changes apply immediately.
class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final cubit = context.read<AppSettingsCubit>();
    final state = context.watch<AppSettingsCubit>().state;

    return SafeArea(
      // heightFactor keeps the sheet as tall as its content.
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ThaheenResponsiveLayout.compactMaxWidth,
          ),
          child: SingleChildScrollView(
            padding: ThaheenSpacing.paddingLarge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.settings,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                ThaheenSpacing.gapVerticalLarge,
                ThaheenChoiceChips<String>(
                  label: l.language,
                  options: {'ar': l.arabic, 'en': l.english},
                  selected: state.settings.localeCode,
                  onSelected: cubit.setLocale,
                ),
                ThaheenSpacing.gapVerticalLarge,
                ThaheenChoiceChips<AppTheme>(
                  label: l.theme,
                  options: {AppTheme.light: l.light, AppTheme.dark: l.dark},
                  selected: state.settings.theme,
                  onSelected: cubit.setTheme,
                ),
                if (state.failure != null) ...[
                  ThaheenSpacing.gapVerticalMedium,
                  ThaheenRetryNotice(onRetry: cubit.retrySave),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
