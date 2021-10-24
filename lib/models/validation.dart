import 'package:enigmamap520/Models/stats_model.dart';
import 'package:enigmamap520/pages/intro.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth.dart';

class ValidationScreen extends StatefulWidget {
  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  @override
  void initState() {
    super.initState();
    checkPref();
  }

  Future<void> checkPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool _seen = prefs.getBool('seen') ?? false;
    if (_seen) {
      setState(() {
        getCurrentUser(context);
        checkingCurrentUser(context);
        getAmount();
      });
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<dynamic>(
          builder: (
            BuildContext context,
          ) =>
              const IntroScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const SpinKitSquareCircle spinKit = SpinKitSquareCircle(
      color: Colors.white,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            AppLocalizations.instance.translate('loading'),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(
            height: 32,
          ),
          spinKit,
        ],
      ),
    );
  }

  void onButtonTapped(BuildContext context) {
    Navigator.of(context).pop();
  }
}
