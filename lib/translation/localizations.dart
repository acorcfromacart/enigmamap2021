import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations._internal();
  static final AppLocalizations _singleton = AppLocalizations._internal();

  static AppLocalizations get instance => _singleton;

  Map<dynamic, dynamic> _localisedValues;

  Future<AppLocalizations> load(Locale locale) async {
    final String jsonContent =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    _localisedValues = json.decode(jsonContent) as Map<dynamic, dynamic>;
    return this;
  }

  String translate(String key) {
    return _localisedValues[key] as String;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'pt'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.instance.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}
