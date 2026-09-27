import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/di/thaheen_module.dart';
import 'package:thaheen_task/app/router/thaheen_app_router.dart';
import 'package:thaheen_task/core/design_system/theme/thaheen_theme.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Root widget: owns the router, provides app-wide cubits from [module], and
/// rebuilds [MaterialApp.router] when the locale or theme setting changes.
class ThaheenWidget extends StatefulWidget {
  const ThaheenWidget({required this.module, super.key});

  final ThaheenModule module;

  @override
  State<ThaheenWidget> createState() => _ThaheenWidgetState();
}

class _ThaheenWidgetState extends State<ThaheenWidget> {
  late final GoRouter _router = createAppRouter(widget.module);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final module = widget.module;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: module.settings),
        BlocProvider.value(value: module.progress),
      ],
      child: BlocBuilder<AppSettingsCubit, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
            locale: Locale(state.settings.localeCode),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            theme: ThaheenTheme.light,
            darkTheme: ThaheenTheme.dark,
            themeMode: state.settings.theme == AppTheme.dark
                ? ThemeMode.dark
                : ThemeMode.light,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
