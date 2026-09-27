import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/router/route_paths.dart';
import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_sizes.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Thumbnail, title, instructor and completion bar; opens the course.
class CourseCard extends StatelessWidget {
  const CourseCard({
    required this.course,
    required this.completedLessonIds,
    super.key,
  });

  final CourseEntity course;
  final Set<String> completedLessonIds;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final lessons = course.lessons;
    final fraction = ProgressRules.calculateCourseProgress(
      completedLessons: lessons
          .where((lesson) => completedLessonIds.contains(lesson.id))
          .length,
      totalLessons: lessons.length,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(RoutePaths.course(course.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                course.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Semantics(
                  label: course.title,
                  child: const Icon(
                    Icons.menu_book,
                    size: ThaheenSizes.iconDisplay,
                  ),
                ),
              ),
            ),
            Padding(
              padding: ThaheenSpacing.paddingCard,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: textTheme.titleLarge),
                  ThaheenSpacing.gapVerticalSmall,
                  Text(course.instructor),
                  ThaheenSpacing.gapVerticalMedium,
                  Text(l.lessonsCount(lessons.length)),
                  ThaheenSpacing.gapVerticalMediumSmall,
                  LinearProgressIndicator(
                    value: fraction,
                    semanticsLabel: l.inProgress,
                  ),
                  ThaheenSpacing.gapVerticalSmall,
                  Text(l.percentage((fraction * 100).round())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
