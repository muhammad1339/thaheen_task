import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';

class AppSettingsState {
  const AppSettingsState({
    this.settings = const AppSettingsEntity(),
    this.failure,
  });
  final AppSettingsEntity settings;
  final Failure? failure;

  @override
  String toString() =>
      'AppSettingsState(locale: ${settings.localeCode}, '
      'theme: ${settings.theme.name}, speed: ${settings.playbackSpeed}, '
      'failure: $failure)';
}
