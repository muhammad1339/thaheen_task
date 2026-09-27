import 'package:flutter_bloc/flutter_bloc.dart';

/// Leaving stays active until navigation completes or the user cancels.
enum PlayerNavigationState { idle, confirming, allowed }

class PlayerNavigationCubit extends Cubit<PlayerNavigationState> {
  PlayerNavigationCubit() : super(PlayerNavigationState.idle);

  bool beginLeave() {
    if (isClosed || state != PlayerNavigationState.idle) return false;
    emit(PlayerNavigationState.confirming);
    return true;
  }

  void allowLeave() {
    if (!isClosed) emit(PlayerNavigationState.allowed);
  }

  void cancelLeave() {
    if (!isClosed) emit(PlayerNavigationState.idle);
  }
}
