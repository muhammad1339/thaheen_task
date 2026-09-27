import 'package:hive_flutter/hive_flutter.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/features/settings/domain/repository/app_settings_repository.dart';

class HiveAppSettingsRepository implements AppSettingsRepository {
  HiveAppSettingsRepository(this.box);
  final Box<dynamic> box;
  @override
  Future<Result<AppSettingsEntity>> load() async {
    try {
      final locale = box.get('settings/locale');
      final speed = box.get('settings/playbackSpeed');
      return Success(
        AppSettingsEntity(
          localeCode: locale == 'en' ? 'en' : 'ar',
          theme: box.get('settings/themeMode') == 'dark'
              ? AppTheme.dark
              : AppTheme.light,
          playbackSpeed: AppSettingsEntity.speeds.contains(speed)
              ? (speed as num).toDouble()
              : 1.0,
        ),
      );
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }

  @override
  Future<Result<void>> save(AppSettingsEntity settings) async {
    try {
      await box.putAll({
        'settings/locale': settings.localeCode,
        'settings/themeMode': settings.theme.name,
        'settings/playbackSpeed': settings.playbackSpeed,
      });
      await box.flush();
      return const Success(null);
    } catch (_) {
      return const FailureResult(Failure(FailureType.storage));
    }
  }
}
