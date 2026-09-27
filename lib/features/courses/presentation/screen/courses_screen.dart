import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/spacing/thaheen_spacing.dart';
import 'package:thaheen_task/core/design_system/thaheen_responsive_layout.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_empty_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_error_state_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_loading_view.dart';
import 'package:thaheen_task/core/design_system/widgets/feedback/thaheen_retry_notice.dart';
import 'package:thaheen_task/core/design_system/widgets/layout/thaheen_centered_content.dart';
import 'package:thaheen_task/core/design_system/widgets/navigation/thaheen_app_bar.dart';
import 'package:thaheen_task/features/courses/domain/continue_watching.dart';
import 'package:thaheen_task/features/courses/domain/repository/course_repository.dart';
import 'package:thaheen_task/features/courses/presentation/bloc/courses_cubit.dart';
import 'package:thaheen_task/features/courses/presentation/widget/continue_watching_card.dart';
import 'package:thaheen_task/features/courses/presentation/widget/course_grid.dart';
import 'package:thaheen_task/features/progress/presentation/bloc/progress_cubit.dart';
import 'package:thaheen_task/features/settings/presentation/widget/settings_button.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

/// Home screen: search, "continue watching", and the course grid.
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({required this.repository, super.key});

  final CourseRepository repository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesCubit(repository)..load(),
      child: Scaffold(
        appBar: ThaheenAppBar(
          title: Text(AppLocalizations.of(context).courses),
          actions: const [SettingsButton()],
        ),
        body: SafeArea(
          child: BlocBuilder<CoursesCubit, CoursesState>(
            builder: (context, courses) =>
                BlocBuilder<ProgressCubit, ProgressState>(
                  builder: (context, progress) =>
                      _CoursesBody(courses: courses, progress: progress),
                ),
          ),
        ),
      ),
    );
  }
}

class _CoursesBody extends StatelessWidget {
  const _CoursesBody({required this.courses, required this.progress});

  final CoursesState courses;
  final ProgressState progress;

  @override
  Widget build(BuildContext context) {
    if (courses.loading || progress.loading) return const ThaheenLoadingView();
    if (courses.failure != null) {
      return ThaheenErrorStateView(onRetry: context.read<CoursesCubit>().load);
    }
    if (!progress.loaded) {
      return ThaheenErrorStateView(onRetry: context.read<ProgressCubit>().load);
    }
    if (courses.courses.isEmpty) {
      return ThaheenEmptyStateView(
        message: AppLocalizations.of(context).emptyCourses,
      );
    }
    return _CourseList(courses: courses, progress: progress);
  }
}

class _CourseList extends StatelessWidget {
  const _CourseList({required this.courses, required this.progress});

  final CoursesState courses;
  final ProgressState progress;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final continuation = findContinueWatching(
      courses: courses.courses,
      progressByLessonId: progress.progressByLessonId,
      completedLessonIds: progress.completedIds,
    );
    final visibleCourses = courses.filtered;

    return ThaheenCenteredContent(
      maxWidth: ThaheenResponsiveLayout.maxContentWidth,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: ThaheenSpacing.paddingLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.offline, style: Theme.of(context).textTheme.titleLarge),
              ThaheenSpacing.gapVerticalLarge,
              TextField(
                decoration: InputDecoration(
                  labelText: l.search,
                  prefixIcon: const Icon(Icons.search),
                ),
                onChanged: context.read<CoursesCubit>().setQuery,
              ),
              ThaheenSpacing.gapVerticalLarge,
              if (progress.failure != null)
                ThaheenRetryNotice(
                  onRetry: context.read<ProgressCubit>().retryPending,
                ),
              if (continuation case (final course, final lesson)) ...[
                ContinueWatchingCard(course: course, lesson: lesson),
                ThaheenSpacing.gapVerticalLarge,
              ],
              if (visibleCourses.isEmpty)
                ThaheenEmptyStateView(message: l.noResults)
              else
                CourseGrid(
                  courses: visibleCourses,
                  columns: ThaheenResponsiveLayout.courseColumns(
                    constraints.maxWidth,
                  ),
                  completedLessonIds: progress.completedIds,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
