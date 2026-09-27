import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';

abstract interface class AppSettingsRepository {
  Future<Result<AppSettingsEntity>> load();
  Future<Result<void>> save(AppSettingsEntity settings);
}
