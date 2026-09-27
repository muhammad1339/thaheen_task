import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/features/settings/domain/entity/app_settings_entity.dart';
import 'package:thaheen_task/features/settings/domain/repository/app_settings_repository.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_state.dart';
export 'package:thaheen_task/features/settings/presentation/bloc/app_settings_state.dart';

class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit(this.repository) : super(const AppSettingsState());
  final AppSettingsRepository repository;
  Future<void> _queue = Future.value();
  int _revision = 0;
  Future<void> load() async {
    final result = await repository.load();
    if (isClosed) return;
    switch (result) {
      case Success<AppSettingsEntity>(:final value):
        emit(AppSettingsState(settings: value));
      case FailureResult<AppSettingsEntity>(:final failure):
        emit(AppSettingsState(settings: state.settings, failure: failure));
    }
  }

  Future<void> setLocale(String value) =>
      _save(state.settings.copyWith(localeCode: value == 'en' ? 'en' : 'ar'));
  Future<void> setTheme(AppTheme value) =>
      _save(state.settings.copyWith(theme: value));
  Future<void> setPlaybackSpeed(double value) => _save(
    state.settings.copyWith(
      playbackSpeed: AppSettingsEntity.speeds.contains(value) ? value : 1.0,
    ),
  );
  Future<void> retrySave() => _save(state.settings);
  Future<void> _save(AppSettingsEntity settings) {
    final revision = ++_revision;
    emit(AppSettingsState(settings: settings));
    return _queue = _queue.then((_) async {
      final result = await repository.save(settings);
      if (isClosed || revision != _revision) return;
      emit(
        AppSettingsState(
          settings: state.settings,
          failure: result is FailureResult<void> ? result.failure : null,
        ),
      );
    });
  }

  @override
  Future<void> close() async {
    await _queue;
    await super.close();
  }
}
