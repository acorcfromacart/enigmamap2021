import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';

import 'get_location_map.dart';

class UploadCompleteScreen extends StatefulWidget {
  @override
  _UploadCompleteScreenState createState() => _UploadCompleteScreenState();
}

class _UploadCompleteScreenState extends State<UploadCompleteScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image(
                image: AssetImage('images/flying_saurce.gif'),
              ),
            ),
            Text(
              AppLocalizations.instance
                  .translate('ufo_set_text'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 21),
            ),
            SizedBox(height: 24,),
            goBackToCategory(),
          ],
        ),
      ),
    );
  }

  Widget goBackToCategory() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/map');
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(0xff111724),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  AppLocalizations.instance
                      .translate('abduction'),
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
