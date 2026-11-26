import 'package:flutter/widgets.dart';
import 'ar_strings.dart';
import 'en_strings.dart';

/// Lightweight, scalable localization delegate supporting Arabic RTL (default)
/// and future English LTR expansion without third-party codegen friction.
class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        const AppLocalizations(Locale('ar'));
  }

  bool get isArabic => locale.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  String text(String key) {
    final Map<String, String> map = isArabic ? arStrings : enStrings;
    return map[key] ?? arStrings[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'ar' || locale.languageCode == 'en';

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
