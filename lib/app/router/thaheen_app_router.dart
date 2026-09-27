import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/di/thaheen_module.dart';
import 'package:thaheen_task/app/router/route_paths.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_error_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/navigation/thaheen_app_bar.dart';
import 'package:thaheen_task/features/courses/presentation/screen/course_details_screen.dart';
import 'package:thaheen_task/features/courses/presentation/screen/courses_screen.dart';
import 'package:thaheen_task/features/player/presentation/screen/lesson_player_screen.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Builds the app router. Each route lives in its own function below; to add
/// a screen, add a path to [RoutePaths] and a route function, then list it
/// under its parent.
///
/// Route tree:
///   /                                   → redirects to /courses
///   /courses                            → CoursesScreen
///   /courses/:courseId                  → CourseDetailsScreen
///   /courses/:courseId/lessons/:lessonId → LessonPlayerScreen
///   anything else                       → not-found screen
GoRouter createAppRouter(ThaheenModule module) {
  return GoRouter(
    initialLocation: RoutePaths.courses,
    errorBuilder: (_, _) => const _NotFoundScreen(),
    routes: [
      GoRoute(path: RoutePaths.root, redirect: (_, _) => RoutePaths.courses),
      _coursesRoute(module),
    ],
  );
}

GoRoute _coursesRoute(ThaheenModule module) {
  return GoRoute(
    path: RoutePaths.courses,
    builder: (_, _) => CoursesScreen(repository: module.courses),
    routes: [_courseDetailsRoute(module)],
  );
}

GoRoute _courseDetailsRoute(ThaheenModule module) {
  return GoRoute(
    path: RoutePaths.coursePattern,
    builder: (_, state) {
      final courseId = state.param(RoutePaths.courseIdParam);
      return CourseDetailsScreen(
        // A new key per course, so moving straight from one course URL to
        // another builds a fresh screen instead of keeping the old course.
        key: ValueKey(courseId),
        repository: module.courses,
        courseId: courseId,
      );
    },
    routes: [_lessonPlayerRoute(module)],
  );
}

GoRoute _lessonPlayerRoute(ThaheenModule module) {
  return GoRoute(
    path: RoutePaths.lessonPattern,
    builder: (_, state) {
      final lessonId = state.param(RoutePaths.lessonIdParam);
      return LessonPlayerScreen(
        // A new key per lesson gives "Next lesson" a fresh player and notes.
        key: ValueKey(lessonId),
        courses: module.courses,
        notesRepository: module.notes,
        courseId: state.param(RoutePaths.courseIdParam),
        lessonId: lessonId,
      );
    },
  );
}

extension on GoRouterState {
  /// A path parameter that the matched route pattern guarantees is present.
  String param(String name) => pathParameters[name]!;
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThaheenAppBar(),
      body: ThaheenErrorStateView(
        message: AppLocalizations.of(context).notFound,
      ),
    );
  }
}
