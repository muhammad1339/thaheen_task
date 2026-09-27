import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/router/route_paths.dart';
import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_sizes.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Highlighted shortcut back into the lesson the learner left unfinished.
class ContinueWatchingCard extends StatelessWidget {
  const ContinueWatchingCard({
    required this.course,
    required this.lesson,
    super.key,
  });

  final CourseEntity course;
  final LessonEntity lesson;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        contentPadding: ThaheenSpacing.paddingCard,
        leading: const Icon(
          Icons.play_circle_outline,
          size: ThaheenSizes.iconLarge,
        ),
        title: Text(l.continueWatching),
        subtitle: Text(l.continuationSubtitle(course.title, lesson.title)),
        onTap: () => context.push(RoutePaths.lesson(course.id, lesson.id)),
      ),
    );
  }
}
