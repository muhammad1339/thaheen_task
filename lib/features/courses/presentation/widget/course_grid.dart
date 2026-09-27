import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/presentation/widget/course_card.dart';

/// Grid of equal-width [CourseCard]s in [columns] columns.
///
/// The caller picks [columns] from the page width (see
/// `ThaheenResponsiveLayout.courseColumns`), so breakpoints follow the window,
/// not the padded grid.
class CourseGrid extends StatelessWidget {
  const CourseGrid({
    required this.courses,
    required this.columns,
    required this.completedLessonIds,
    super.key,
  });

  final List<CourseEntity> courses;
  final int columns;
  final Set<String> completedLessonIds;

  static const _gap = ThaheenSpacing.medium;

  // Shave a hair off each card so float rounding never makes Wrap push the
  // last card of a row onto the next line.
  static const _roundingSafety = 0.01;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth =
            ((width - (columns - 1) * _gap) / columns - _roundingSafety).clamp(
              0.0,
              width,
            );
        return Wrap(
          spacing: _gap,
          runSpacing: _gap,
          children: [
            for (final course in courses)
              SizedBox(
                width: cardWidth,
                child: CourseCard(
                  course: course,
                  completedLessonIds: completedLessonIds,
                ),
              ),
          ],
        );
      },
    );
  }
}
