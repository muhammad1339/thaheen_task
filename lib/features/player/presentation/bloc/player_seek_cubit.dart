import 'package:flutter_bloc/flutter_bloc.dart';

/// Keeps drag previews separate from the persisted playback position.
class PlayerSeekCubit extends Cubit<double?> {
  PlayerSeekCubit() : super(null);
  int _revision = 0;

  void preview(double milliseconds) {
    if (isClosed) return;
    ++_revision;
    emit(milliseconds);
  }

  Future<void> commit(
    double milliseconds,
    Future<void> Function(Duration) seek,
  ) async {
    if (isClosed) return;
    final revision = ++_revision;
    emit(milliseconds);
    try {
      await seek(Duration(milliseconds: milliseconds.round()));
    } finally {
      if (!isClosed && revision == _revision) emit(null);
    }
  }
}
