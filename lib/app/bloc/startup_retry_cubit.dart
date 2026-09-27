import 'package:flutter_bloc/flutter_bloc.dart';

/// Whether a startup retry is in progress (`true`) on the startup error
/// page: drives its spinner and ignores repeat taps until the retry settles.
class StartupRetryCubit extends Cubit<bool> {
  StartupRetryCubit() : super(false);

  Future<void> retry(Future<void> Function() action) async {
    if (isClosed || state) return;
    emit(true);
    try {
      await action();
    } finally {
      if (!isClosed) emit(false);
    }
  }
}
