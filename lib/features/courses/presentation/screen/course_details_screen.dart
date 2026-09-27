import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_responsive_layout.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_empty_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_error_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_loading_view.dart';
import 'package:thaheen_task/core/design_system/widgets/layout/thaheen_centered_content.dart';
import 'package:thaheen_task/core/design_system/widgets/navigation/thaheen_app_bar.dart';
import 'package:thaheen_task/core/presentation/failure_message.dart';
import 'package:thaheen_task/features/courses/domain/entity/course_entity.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/courses/presentation/bloc/course_details_cubit.dart';
import 'package:thaheen_task/features/courses/presentation/widget/lesson_tile.dart';
import 'package:thaheen_task/features/progress/domain/lesson_status.dart';
import 'package:thaheen_task/features/progress/domain/progress_rules.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/widget/settings_button.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// A course's sections and lessons, each with its status for this learner.
class CourseDetailsScreen extends StatelessWidget {
  const CourseDetailsScreen({
    required this.repository,
    required this.courseId,
    super.key,
  });

  final CourseRepository repository;
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CourseDetailsCubit(repository)..load(courseId),
      child: BlocBuilder<CourseDetailsCubit, CourseDetailsState>(
        builder: (context, details) => Scaffold(
          appBar: ThaheenAppBar(
            title: Text(
              details.course?.title ?? AppLocalizations.of(context).courses,
            ),
            actions: const [SettingsButton()],
          ),
          body: SafeArea(
            child: BlocBuilder<ProgressCubit, ProgressState>(
              builder: (context, progress) => _CourseDetailsBody(
                courseId: courseId,
                details: details,
                progress: progress,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CourseDetailsBody extends StatelessWidget {
  const _CourseDetailsBody({
    required this.courseId,
    required this.details,
    required this.progress,
  });

  final String courseId;
  final CourseDetailsState details;
  final ProgressState progress;

  @override
  Widget build(BuildContext context) {
    if (details.loading || progress.loading) return const ThaheenLoadingView();
    final course = details.course;
    if (course == null) {
      return ThaheenErrorStateView(
        message: details.failure?.localizedMessage(
          AppLocalizations.of(context),
        ),
        onRetry: () => context.read<CourseDetailsCubit>().load(courseId),
      );
    }
    if (!progress.loaded) {
      return ThaheenErrorStateView(onRetry: context.read<ProgressCubit>().load);
    }
    if (course.lessons.isEmpty) {
      return ThaheenEmptyStateView(
        message: AppLocalizations.of(context).emptyCourse,
      );
    }
    return _LessonList(course: course, progress: progress);
  }
}

class _LessonList extends StatelessWidget {
  const _LessonList({required this.course, required this.progress});

  final CourseEntity course;
  final ProgressState progress;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    LessonStatus statusOf(LessonEntity lesson) => LessonStatus.resolve(
      unlocked: ProgressRules.isLessonUnlocked(
        lessonId: lesson.id,
        orderedLessonIds: course.lessonIds,
        completedLessonIds: progress.completedIds,
      ),
      progress: progress.progressByLessonId[lesson.id],
    );

    return ThaheenCenteredContent(
      maxWidth: ThaheenResponsiveLayout.maxReaderWidth,
      child: ListView(
        padding: ThaheenSpacing.paddingLarge,
        children: [
          Text(course.instructor, style: textTheme.titleMedium),
          ThaheenSpacing.gapVerticalLarge,
          for (final section in course.sections) ...[
            Text(section.title, style: textTheme.headlineSmall),
            ThaheenSpacing.gapVerticalMediumSmall,
            for (final lesson in section.lessons)
              LessonTile(
                courseId: course.id,
                lesson: lesson,
                status: statusOf(lesson),
              ),
            ThaheenSpacing.gapVerticalLarge,
          ],
        ],
      ),
    );
  }
}
