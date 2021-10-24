import 'package:enigmamap520/models/validation.dart';
import 'package:enigmamap520/pages/about.dart';
import 'package:enigmamap520/pages/home_page.dart';
import 'package:enigmamap520/pages/intro.dart';
import 'package:enigmamap520/pages/privacy_policy.dart';
import 'package:enigmamap520/pages/pro_version.dart';
import 'package:enigmamap520/pages/sign_in.dart';
import 'package:enigmamap520/pages/terms.dart';
import 'package:enigmamap520/recordedDatas/recorded_datas.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
      builder: (BuildContext context, Widget widget) =>
          ResponsiveWrapper.builder(
        BouncingScrollWrapper.builder(context, widget),
        maxWidth: 1200,
        minWidth: 420,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      title: 'Ufo Tracker',
      debugShowCheckedModeBanner: false,
      initialRoute: '/validation',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/intro':
            return MaterialPageRoute<dynamic>(
              builder: (_) => const IntroScreen(),
            );
          case '/map':
            return MaterialPageRoute<dynamic>(builder: (_) => HomePage());
          case '/signIn':
            return MaterialPageRoute<dynamic>(builder: (_) => SignInScreen());
          case '/rec':
            return MaterialPageRoute<dynamic>(builder: (_) => RecordedData());
          case '/about':
            return MaterialPageRoute<dynamic>(builder: (_) => AboutScreen());
          case '/privacy':
            return MaterialPageRoute<dynamic>(builder: (_) => PrivacyPolicy());
          case '/terms':
            return MaterialPageRoute<dynamic>(builder: (_) => Terms());
          case '/add':
            return MaterialPageRoute<dynamic>(
              builder: (_) => const GetMapLocationScreen(),
            );
          case '/pro':
            return MaterialPageRoute<dynamic>(builder: (_) => ProVersion());
          case '/validation':
          default:
            return MaterialPageRoute<dynamic>(
              builder: (_) => ValidationScreen(),
            );
        }
      },
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('en', 'CA'),
        Locale('en', 'AU'),
        Locale('es', 'MX'),
        Locale('es', 'ES'),
        Locale('fr', 'FR'),
        Locale('ko', 'KO'),
        Locale('ru', 'RU'),

        // ... other locales the app supports
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (final Locale supportedLocale in supportedLocales) {
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
