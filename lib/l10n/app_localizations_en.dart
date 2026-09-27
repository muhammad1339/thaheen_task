// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Thaheen';

  @override
  String get courses => 'My courses';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get theme => 'Appearance';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get retry => 'Retry';

  @override
  String get error => 'Something went wrong. Please try again.';

  @override
  String get notSaved => 'Changes have not been saved.';

  @override
  String get notFound => 'This content is not available.';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyCourses => 'No courses yet';

  @override
  String get emptyCourse => 'This course has no lessons yet';

  @override
  String get search => 'Search courses or instructors';

  @override
  String get noResults => 'No matching courses';

  @override
  String get continueWatching => 'Continue watching';

  @override
  String get lessons => 'Lessons';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In progress';

  @override
  String get notStarted => 'Not started';

  @override
  String get locked => 'Locked';

  @override
  String get lockedMessage =>
      'Complete the previous lesson to unlock this lesson.';

  @override
  String get nextLesson => 'Next lesson';

  @override
  String get courseEnd => 'You reached the last lesson';

  @override
  String get notes => 'Lesson notes';

  @override
  String get noteHint => 'Write your notes here…';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get discard => 'Discard';

  @override
  String get cancel => 'Cancel';

  @override
  String get unsavedNotes => 'Save your notes before leaving?';

  @override
  String get leave => 'Leave';

  @override
  String get unsavedProgress =>
      'Your latest position has not been saved. Retry or leave anyway?';

  @override
  String get speed => 'Playback speed';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get fullscreen => 'Fullscreen';

  @override
  String get exitFullscreen => 'Exit fullscreen';

  @override
  String get offline => 'Learn at your own pace, offline.';

  @override
  String get mediaError => 'This video could not be played.';

  @override
  String lessonsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lessons',
      one: '1 lesson',
    );
    return '$_temp0';
  }

  @override
  String percentage(Object percent) {
    return '$percent%';
  }

  @override
  String speedLabel(Object speed) {
    return '${speed}x';
  }

  @override
  String playbackTime(Object current, Object total) {
    return '$current / $total';
  }

  @override
  String lessonStatusWithDuration(Object status, Object time) {
    return '$status • $time';
  }

  @override
  String continuationSubtitle(Object courseTitle, Object lessonTitle) {
    return '$courseTitle • $lessonTitle';
  }
}
