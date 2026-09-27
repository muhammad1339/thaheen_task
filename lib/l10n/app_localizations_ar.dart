// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'طحين';

  @override
  String get courses => 'دوراتي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get error => 'حدث خطأ. يرجى المحاولة مرة أخرى.';

  @override
  String get notSaved => 'لم يتم حفظ التغييرات.';

  @override
  String get notFound => 'هذا المحتوى غير متاح.';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get emptyCourses => 'لا توجد دورات بعد';

  @override
  String get emptyCourse => 'لا توجد دروس في هذه الدورة بعد';

  @override
  String get search => 'ابحث عن دورة أو مدرّس';

  @override
  String get noResults => 'لا توجد دورات مطابقة';

  @override
  String get continueWatching => 'متابعة المشاهدة';

  @override
  String get lessons => 'الدروس';

  @override
  String get completed => 'مكتمل';

  @override
  String get inProgress => 'قيد التقدم';

  @override
  String get notStarted => 'لم يبدأ';

  @override
  String get locked => 'مقفل';

  @override
  String get lockedMessage => 'أكمل الدرس السابق لفتح هذا الدرس.';

  @override
  String get nextLesson => 'الدرس التالي';

  @override
  String get courseEnd => 'وصلت إلى الدرس الأخير';

  @override
  String get notes => 'ملاحظات الدرس';

  @override
  String get noteHint => 'اكتب ملاحظاتك هنا…';

  @override
  String get save => 'حفظ';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get discard => 'تجاهل';

  @override
  String get cancel => 'إلغاء';

  @override
  String get unsavedNotes => 'هل تريد حفظ الملاحظات قبل المغادرة؟';

  @override
  String get leave => 'مغادرة';

  @override
  String get unsavedProgress =>
      'لم يُحفظ موضع المشاهدة الأخير. أعد المحاولة أو غادر؟';

  @override
  String get speed => 'سرعة التشغيل';

  @override
  String get play => 'تشغيل';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get fullscreen => 'ملء الشاشة';

  @override
  String get exitFullscreen => 'إنهاء ملء الشاشة';

  @override
  String get offline => 'تعلّم على راحتك، دون اتصال.';

  @override
  String get mediaError => 'تعذّر تشغيل هذا الفيديو.';

  @override
  String lessonsCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count درس',
      many: '$count درساً',
      few: '$count دروس',
      two: 'درسان',
      one: 'درس واحد',
    );
    return '$_temp0';
  }

  @override
  String percentage(Object percent) {
    return '$percent٪';
  }

  @override
  String speedLabel(Object speed) {
    return '$speed×';
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
