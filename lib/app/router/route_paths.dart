/// Route patterns and location builders used by the app router.
abstract final class RoutePaths {
  /// Path parameter names, shared by the patterns below and the router that
  /// reads them.
  static const courseIdParam = 'courseId';
  static const lessonIdParam = 'lessonId';

  /// Shared by [lessonPattern] and [lesson] so the router and the links it
  /// matches can't drift apart.
  static const _lessonsSegment = 'lessons';

  static const root = '/';
  static const courses = '/courses';
  static const coursePattern = ':$courseIdParam';
  static const lessonPattern = '$_lessonsSegment/:$lessonIdParam';

  static String course(String courseId) => '$courses/$courseId';
  static String lesson(String courseId, String lessonId) =>
      '${course(courseId)}/$_lessonsSegment/$lessonId';
}
