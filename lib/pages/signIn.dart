import 'package:enigmamap520/Models/auth.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: loginImg(),
            ),
            enigmaTxt(),
            enigmaDes(),
            roundedSignInButton(),
          ],
        ),
      ),
    );
  }

  loginImg() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 21.0, right: 21, top: 42),
        child: Image.asset(
          'images/main.png',
          // width: 207,
          // height: 192,
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }

  enigmaTxt() {
    return Text(
      'Ufo Tracker',
      style: TextStyle(
          fontSize: 42,
          color: Colors.white,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.bold),
    );
  }

  enigmaDes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 32, right: 32),
      child: Text(
        AppLocalizations.instance.translate("description_text"),
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 24, color: Colors.grey, fontFamily: 'Roboto'),
      ),
    );
  }

  roundedSignInButton() {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 32, right: 32, bottom: 42),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 62,
            child: ElevatedButton(
              child: Text(
                AppLocalizations.instance.translate("sign_in"),
                style: TextStyle(color: Colors.black87, fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)))),
              onPressed: () {
                ///Login with Google
                signInWithGoogle(context).then((result) {
                  if (userId != null) {
                    Navigator.pushReplacementNamed(context, '/map');
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
