import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/app/di/thaheen_module.dart';
import 'package:thaheen_task/app/widget/thaheen_start_error_page.dart';
import 'package:thaheen_task/app/widget/thaheen_widget.dart';
import 'package:thaheen_task/core/domain/errors/exceptions.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_cubit.dart';
import 'package:thaheen_task/utils/logger/app_logger.dart';
import 'package:thaheen_task/utils/logger/bloc_logger.dart';

/// Opens local storage and builds the app's [ThaheenModule].
typedef ModuleOpener = Future<ThaheenModule> Function();

/// Boots the app: opens the [ThaheenModule], then runs [ThaheenWidget].
///
/// A [ThaheenStartupException] shows [ThaheenStartErrorPage] with a retry
/// that boots again. Any other error is a bug: it is rethrown in debug so it
/// surfaces immediately, and shown without a retry in release.
Future<void> thaheenApp({ModuleOpener open = ThaheenModule.open}) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    Bloc.observer = BlocLogger(skipChangesOf: {PlayerCubit});
  }
  try {
    final module = await open();
    runApp(ThaheenWidget(module: module));
  } on ThaheenStartupException catch (error, stackTrace) {
    _logStartupFailure(error, stackTrace);
    runApp(ThaheenStartErrorPage(onRetry: () => thaheenApp(open: open)));
  } catch (error, stackTrace) {
    _logStartupFailure(error, stackTrace);
    if (kDebugMode) rethrow;
    runApp(const ThaheenStartErrorPage());
  }
}

void _logStartupFailure(Object error, StackTrace stackTrace) {
  AppLogger.e(
    'Critical error during bootstrap',
    tag: 'Bootstrap',
    error: error,
    stackTrace: stackTrace,
  );
}
