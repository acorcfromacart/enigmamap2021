import 'package:enigmamap520/Screens/MainScreen/ProVersion/pro_version.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'Models/validation.dart';
import 'Screens/MainScreen/AboutScreen/privacy_policy.dart';
import 'Screens/MainScreen/AboutScreen/terms.dart';
import 'Screens/MainScreen/recorded_datas.dart';
import 'Screens/MainScreen/SignInScreen/signIn.dart';
import 'Screens/MainScreen/AboutScreen/about.dart';
import 'Screens/MainScreen/main_screen.dart';
import 'SendForm/get_location_map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(EnigmaMap());
}

class EnigmaMap extends StatefulWidget {
  @override
  _EnigmaMapState createState() => _EnigmaMapState();
}

class _EnigmaMapState extends State<EnigmaMap> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///Trying to build responsive app
      builder: (context, widget) => ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 420,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480,name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ]
      ),
      title: 'Enigma Map',
      debugShowCheckedModeBanner: false,
      initialRoute: '/validation',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/map':
            return MaterialPageRoute(builder: (_) => MainScreen());
          case '/signIn':
            return MaterialPageRoute(builder: (_) => SignInScreen());
          case '/rec':
            return MaterialPageRoute(builder: (_) => RecordedData());
          case '/about':
            return MaterialPageRoute(builder: (_) => AboutScreen());
          case '/privacy':
            return MaterialPageRoute(builder: (_) => PrivacyPolicy());
          case '/terms':
            return MaterialPageRoute(builder: (_) => Terms());
          case '/add':
            return MaterialPageRoute(builder: (_) => GetMapLocationScreen());
          case '/pro':
            return MaterialPageRoute(builder: (_) => ProVersion());
          case '/validation':
          default:
            return MaterialPageRoute(builder: (_) => ValidationScreen());
        }
      },
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('pt', 'BR'),
        const Locale('en', 'CA'),
        const Locale('en', 'AU'),
        const Locale('es', 'MX'),
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('ko', 'KO'),
        const Locale('ru', 'RU'),

        // ... other locales the app supports
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );
  }
}
