import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/router/route_paths.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_error_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_loading_view.dart';
import 'package:thaheen_task/core/design_system/widgets/navigation/thaheen_app_bar.dart';
import 'package:thaheen_task/core/presentation/failure_message.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/notes/domain/repository/lesson_notes_repository.dart';
import 'package:thaheen_task/features/notes/presentation/bloc/lesson_notes_cubit.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_cubit.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_navigation_cubit.dart';
import 'package:thaheen_task/features/player/presentation/video_session.dart';
import 'package:thaheen_task/features/player/presentation/widget/lesson_info_panel.dart';
import 'package:thaheen_task/features/notes/presentation/widget/unsaved_notes_dialog.dart';
import 'package:thaheen_task/features/player/presentation/widget/player_layout.dart';
import 'package:thaheen_task/features/player/presentation/widget/player_video.dart';
import 'package:thaheen_task/features/player/presentation/widget/unsaved_progress_dialog.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/widget/settings_button.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Plays one lesson. Owns the player, notes and leave-guard cubits, saves
/// progress when backgrounded, and guards every exit (back, next lesson)
/// against unsaved notes or progress.
class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({
    required this.courses,
    required this.notesRepository,
    required this.courseId,
    required this.lessonId,
    this.createVideo,
    super.key,
  });

  final CourseRepository courses;
  final LessonNotesRepository notesRepository;
  final String courseId, lessonId;
  final VideoSession Function(String)? createVideo;

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen>
    with WidgetsBindingObserver {
  late final PlayerCubit _player;
  late final LessonNotesCubit _notes;
  final _navigation = PlayerNavigationCubit();
  final _notesController = TextEditingController();

  // Keep the video and info panel state alive when a resize switches
  // [PlayerLayout] between side-by-side and stacked.
  final _videoKey = GlobalKey();
  final _infoKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notes = LessonNotesCubit(widget.notesRepository)..load(widget.lessonId);
    _player = PlayerCubit(
      widget.courses,
      context.read<ProgressCubit>(),
      context.read<AppSettingsCubit>(),
      createVideo: widget.createVideo,
    )..open(courseId: widget.courseId, lessonId: widget.lessonId);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_player.close());
    unawaited(_notes.close());
    unawaited(_navigation.close());
    _notesController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      unawaited(_player.background());
    }
  }

  /// Runs [navigate] only once unsaved notes are resolved and progress is
  /// saved (or the user chooses to leave without it).
  Future<void> _leave(VoidCallback navigate) async {
    if (!_navigation.beginLeave()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      if (!await confirmNotesLeave(context, _notes) || !mounted) return;
      final progressSaved = await _player.flush();
      if (!mounted) return;
      if (!progressSaved &&
          !await showUnsavedProgressDialog(context, retry: _player.flush)) {
        return;
      }
      if (!mounted) return;
      _navigation.allowLeave();
      await WidgetsBinding.instance.endOfFrame;
      if (mounted) navigate();
    } finally {
      if (mounted) _navigation.cancelLeave();
    }
  }

  void _back() => _leave(() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RoutePaths.course(widget.courseId));
    }
  });

  void _nextLesson(String lessonId) => _leave(
    () => context.pushReplacement(RoutePaths.lesson(widget.courseId, lessonId)),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerNavigationCubit, PlayerNavigationState>(
      bloc: _navigation,
      builder: (context, navigation) => PopScope(
        canPop: navigation == PlayerNavigationState.allowed,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) _back();
        },
        child: Scaffold(
          appBar: ThaheenAppBar(
            leading: BackButton(onPressed: _back),
            title: BlocBuilder<PlayerCubit, PlayerState>(
              bloc: _player,
              builder: (context, state) => Text(
                state.lesson?.title ?? AppLocalizations.of(context).lessons,
              ),
            ),
            actions: const [SettingsButton()],
          ),
          body: SafeArea(
            child: BlocBuilder<PlayerCubit, PlayerState>(
              bloc: _player,
              builder: (context, state) => _LessonPlayerBody(
                state: state,
                navigation: navigation,
                player: _player,
                notes: _notes,
                notesController: _notesController,
                videoKey: _videoKey,
                infoKey: _infoKey,
                onNextLesson: _nextLesson,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonPlayerBody extends StatelessWidget {
  const _LessonPlayerBody({
    required this.state,
    required this.navigation,
    required this.player,
    required this.notes,
    required this.notesController,
    required this.videoKey,
    required this.infoKey,
    required this.onNextLesson,
  });

  final PlayerState state;
  final PlayerNavigationState navigation;
  final PlayerCubit player;
  final LessonNotesCubit notes;
  final TextEditingController notesController;
  final GlobalKey videoKey;
  final GlobalKey infoKey;
  final ValueChanged<String> onNextLesson;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    if (state.loading) return const ThaheenLoadingView();
    if (state.locked) return ThaheenErrorStateView(message: l.lockedMessage);
    if (state.failure case final failure?) {
      return ThaheenErrorStateView(
        message: failure.localizedMessage(l),
        onRetry: player.retry,
      );
    }
    if (player.video == null) return const ThaheenLoadingView();

    return PlayerLayout(
      video: PlayerVideo(key: videoKey, player: player),
      info: LessonInfoPanel(
        key: infoKey,
        state: state,
        player: player,
        notes: notes,
        notesController: notesController,
        editingEnabled: navigation == PlayerNavigationState.idle,
        onNextLesson: () => onNextLesson(state.nextLessonId!),
      ),
    );
  }
}
