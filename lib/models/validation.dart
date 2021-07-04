import 'package:enigmamap520/Models/stats_model.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'auth.dart';

class ValidationScreen extends StatefulWidget {
  @override
  _ValidationScreenState createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      getCurrentUser(context);
      checkingCurrentUser(context);
      getAmount();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spinKit = SpinKitSquareCircle(
      color: Colors.white,
      size: 50.0,
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.instance.translate("loading"),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 32,
          ),
          spinKit,
        ],
      ),
    );
  }
}
