import 'package:thaheen_task/core/domain/errors/failures.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';

extension FailureMessage on Failure {
  /// The message to show for this failure, or null to use the generic error.
  String? localizedMessage(AppLocalizations l) => switch (type) {
    FailureType.media => l.mediaError,
    FailureType.notFound => l.notFound,
    FailureType.storage || FailureType.invalidData => null,
  };
}
