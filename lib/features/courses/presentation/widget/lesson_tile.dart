import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:thaheen_task/app/router/route_paths.dart';
import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/progress/domain/lesson_status.dart';
import 'package:thaheen_task/features/progress/presentation/widget/lesson_status_display.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';
import 'package:thaheen_task/utils/duration_formatter.dart';

/// One lesson row: status icon, title, status and duration. Opens the lesson,
/// or explains why it is locked.
class LessonTile extends StatelessWidget {
  const LessonTile({
    required this.courseId,
    required this.lesson,
    required this.status,
    super.key,
  });

  final String courseId;
  final LessonEntity lesson;
  final LessonStatus status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThaheenSpacing.medium,
          vertical: ThaheenSpacing.mediumSmall,
        ),
        leading: Icon(status.icon),
        title: Text(lesson.title),
        subtitle: Text(
          l.lessonStatusWithDuration(
            status.label(l),
            formatDuration(lesson.duration),
          ),
        ),
        onTap: () => _open(context, l),
      ),
    );
  }

  void _open(BuildContext context, AppLocalizations l) {
    if (status == LessonStatus.locked) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.lockedMessage)));
    } else {
      context.push(RoutePaths.lesson(courseId, lesson.id));
    }
  }
}
