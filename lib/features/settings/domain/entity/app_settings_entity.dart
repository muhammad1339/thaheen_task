import 'package:equatable/equatable.dart';

enum AppTheme { light, dark }

class AppSettingsEntity extends Equatable {
  const AppSettingsEntity({
    this.localeCode = 'ar',
    this.theme = AppTheme.light,
    this.playbackSpeed = 1.0,
  });
  static const speeds = [1.0, 1.25, 1.5, 2.0];
  final String localeCode;
  final AppTheme theme;
  final double playbackSpeed;
  AppSettingsEntity copyWith({
    String? localeCode,
    AppTheme? theme,
    double? playbackSpeed,
  }) => AppSettingsEntity(
    localeCode: localeCode ?? this.localeCode,
    theme: theme ?? this.theme,
    playbackSpeed: playbackSpeed ?? this.playbackSpeed,
  );
  @override
  List<Object> get props => [localeCode, theme, playbackSpeed];
}
