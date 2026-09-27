import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/app/bloc/startup_retry_cubit.dart';

import 'package:thaheen_task/core/design_system/theme/thaheen_theme.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_error_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_loading_view.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Shown when bootstrap fails, before settings are available, so it uses the
/// default Arabic locale and light theme.
class ThaheenStartErrorPage extends StatelessWidget {
  const ThaheenStartErrorPage({this.onRetry, super.key});

  /// Boots again; null when retrying cannot help, so no retry is offered.
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThaheenTheme.light,
      home: BlocProvider(
        create: (_) => StartupRetryCubit(),
        child: BlocBuilder<StartupRetryCubit, bool>(
          builder: (context, retrying) => Scaffold(
            body: retrying
                ? const ThaheenLoadingView()
                : ThaheenErrorStateView(
                    onRetry: onRetry == null
                        ? null
                        : () =>
                              context.read<StartupRetryCubit>().retry(onRetry!),
                  ),
          ),
        ),
      ),
    );
  }
}
