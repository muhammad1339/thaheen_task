import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thaheen_task/utils/logger/app_logger.dart';

/// Logs cubit lifecycle, state changes and errors (debug builds only).
class BlocLogger extends BlocObserver {
  BlocLogger({this.skipChangesOf = const {}});

  /// Bloc types whose `onChange` is not logged, for high-frequency emitters
  /// (e.g. a player emitting on every position tick). Their create, close and
  /// errors are still logged.
  final Set<Type> skipChangesOf;

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.d('onCreate -- ${bloc.runtimeType}', tag: 'Bloc');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (skipChangesOf.contains(bloc.runtimeType)) return;
    AppLogger.d('onChange -- ${bloc.runtimeType}, $change', tag: 'Bloc');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.e(
      'onError -- ${bloc.runtimeType}, $error',
      tag: 'Bloc',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.d('onClose -- ${bloc.runtimeType}', tag: 'Bloc');
  }
}
