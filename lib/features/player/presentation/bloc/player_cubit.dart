import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/domain/errors/result.dart';
import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/progress/domain/entity/lesson_progress_entity.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/bloc/app_settings_cubit.dart';
import 'package:thaheen_task/features/player/presentation/video_session.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_state.dart';
export 'package:thaheen_task/features/player/presentation/bloc/player_state.dart';

class PlayerCubit extends Cubit<PlayerState> {
  PlayerCubit(
    this.courses,
    this.progress,
    this.settings, {
    VideoSession Function(String)? createVideo,
  }) : createVideo = createVideo ?? NativeVideoSession.new,
       super(const PlayerState());
  final CourseRepository courses;
  final ProgressCubit progress;
  final AppSettingsCubit settings;
  final VideoSession Function(String) createVideo;
  VideoSession? video;
  Timer? _timer;
  int _generation = 0;
  bool _closing = false;
  String? _courseId, _lessonId;
  Future<void> open({
    required String courseId,
    required String lessonId,
  }) async {
    final generation = ++_generation;
    _courseId = courseId;
    _lessonId = lessonId;
    await flush();
    await _release();
    if (_closing || isClosed || generation != _generation) return;
    emit(const PlayerState(loading: true));
    final result = await courses.getCourseById(courseId);
    if (_closing || isClosed || generation != _generation) return;
    if (result is FailureResult<CourseEntity>) {
      emit(PlayerState(failure: result.failure));
      return;
    }
    if (!progress.state.loaded) {
      await progress.load();
    }
    if (_closing || isClosed || generation != _generation) return;
    if (!progress.state.loaded) {
      emit(PlayerState(failure: progress.state.failure));
      return;
    }
    final course = (result as Success<CourseEntity>).value;
    final lessons = course.lessons;
    final index = course.lessonIds.indexOf(lessonId);
    if (index < 0) {
      emit(const PlayerState(failure: Failure(FailureType.notFound)));
      return;
    }
    if (!ProgressRules.isUnlocked(
      lessonIndex: index,
      orderedLessonIds: course.lessonIds,
      completedLessonIds: progress.state.completedIds,
    )) {
      emit(PlayerState(course: course, locked: true));
      return;
    }
    final lesson = lessons[index];
    final session = createVideo(lesson.videoAsset);
    try {
      await session.initialize();
      if (_closing || isClosed || generation != _generation) {
        await session.release();
        return;
      }
      await session.setSpeed(settings.state.settings.playbackSpeed);
      final saved =
          progress.state.progressByLessonId[lessonId]?.position ??
          Duration.zero;
      await session.seek(
        Duration(
          milliseconds: saved.inMilliseconds.clamp(
            0,
            session.duration.inMilliseconds,
          ),
        ),
      );
      if (_closing || isClosed || generation != _generation) {
        await session.release();
        return;
      }
      video = session;
      emit(
        PlayerState(
          course: course,
          lesson: lesson,
          duration: session.duration,
          position: session.position,
          speed: settings.state.settings.playbackSpeed,
        ),
      );
      session.addListener(_tick);
      _refresh();
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (video?.playing ?? false) unawaited(flush());
      });
    } catch (_) {
      await session.release();
      if (!_closing && !isClosed && generation == _generation) {
        emit(
          PlayerState(
            course: course,
            lesson: lesson,
            failure: const Failure(FailureType.media),
          ),
        );
      }
    }
  }

  void _refresh() {
    final session = video, course = state.course, lesson = state.lesson;
    if (session == null || course == null || lesson == null || isClosed) return;
    final lessonIds = course.lessonIds;
    final index = lessonIds.indexOf(lesson.id);
    final next = index + 1 < lessonIds.length ? lessonIds[index + 1] : null;
    emit(
      PlayerState(
        course: course,
        lesson: lesson,
        position: session.error == null ? session.position : state.position,
        duration: session.error == null ? session.duration : state.duration,
        playing: session.playing,
        speed: settings.state.settings.playbackSpeed,
        nextLessonId: next,
        nextUnlocked:
            next != null &&
            ProgressRules.isUnlocked(
              lessonIndex: index + 1,
              orderedLessonIds: lessonIds,
              completedLessonIds: progress.state.completedIds,
            ),
        saveFailed: progress.state.pending.contains(lesson.id),
        failure: session.error != null
            ? const Failure(FailureType.media)
            : null,
      ),
    );
  }

  void _tick() {
    final wasPlaying = state.playing;
    _refresh();
    final session = video, lesson = state.lesson;
    if (session == null || lesson == null) return;
    final completes =
        ProgressRules.shouldComplete(
          position: session.position,
          duration: session.duration,
        ) &&
        !progress.state.completedIds.contains(lesson.id);
    if (completes || (wasPlaying && !session.playing)) unawaited(flush());
  }

  Future<bool> flush() async {
    final session = video, lesson = state.lesson;
    if (session == null || lesson == null) return true;
    await progress.record(
      LessonProgressEntity(
        lessonId: lesson.id,
        position: session.error == null ? session.position : state.position,
        isCompleted: ProgressRules.shouldComplete(
          position: session.error == null ? session.position : state.position,
          duration: session.error == null ? session.duration : state.duration,
        ),
      ),
    );
    if (!_closing && !isClosed) _refresh();
    return !progress.state.pending.contains(lesson.id);
  }

  Future<void> togglePlayback() async {
    try {
      if (video?.playing ?? false) {
        await video!.pause();
        await flush();
      } else {
        await video?.play();
      }
    } catch (_) {
      await _mediaFailure();
    }
  }

  Future<void> seek(Duration position) async {
    try {
      await video?.seek(position);
      await flush();
    } catch (_) {
      await _mediaFailure();
    }
  }

  Future<void> setSpeed(double speed) async {
    try {
      await video?.setSpeed(speed);
      await settings.setPlaybackSpeed(speed);
      _refresh();
    } catch (_) {
      await _mediaFailure();
    }
  }

  Future<void> background() async {
    await video?.pause();
    await flush();
  }

  /// Saves progress and releases the session before showing the error;
  /// otherwise the next video tick would `_refresh` the error away while
  /// playback continues behind the error view.
  Future<void> _mediaFailure() async {
    await flush();
    await _release();
    if (!_closing && !isClosed) {
      emit(
        PlayerState(
          course: state.course,
          lesson: state.lesson,
          failure: const Failure(FailureType.media),
        ),
      );
    }
  }

  Future<void> retry() async {
    if (_courseId != null && _lessonId != null) {
      await open(courseId: _courseId!, lessonId: _lessonId!);
    }
  }

  Future<void> _release() async {
    _timer?.cancel();
    _timer = null;
    final previous = video;
    video = null;
    if (previous != null) {
      previous.removeListener(_tick);
      await previous.release();
    }
  }

  @override
  Future<void> close() async {
    _closing = true;
    ++_generation;
    await flush();
    await _release();
    await super.close();
  }
}
