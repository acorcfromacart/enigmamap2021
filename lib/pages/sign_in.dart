import 'package:auth_buttons/auth_buttons.dart';
import 'package:enigmamap520/models/auth.dart';
import 'package:enigmamap520/translation/localizations.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isLoading = false;
  bool darkMode = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: loginImg(),
            ),
            enigmaTxt(),
            enigmaDes(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: GoogleAuthButton(
                  onPressed: () {
                    signInWithGoogle(context).then((result) {
                      if (userId != null) {
                        Navigator.pushReplacementNamed(context, '/map');
                      }
                    });
                    setState(() {
                      isLoading = !isLoading;
                    });
                  },
                  darkMode: darkMode,
                  isLoading: isLoading,
                  text: AppLocalizations.instance.translate('sign_in'),
                  style: const AuthButtonStyle(
                    buttonType: AuthButtonType.secondary,
                    iconType: AuthIconType.outlined,
                    padding: EdgeInsets.all(8),
                  ),
                ),
              ),
            )
            //roundedSignInButton(),
          ],
        ),
      ),
    );
  }

  Widget loginImg() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Image.asset(
          'images/intro_slide_img.png',
          // width: 207,
          // height: 192,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }

  Widget enigmaTxt() {
    return const Text(
      'Ufo Tracker',
      style: TextStyle(
        fontSize: 42,
        color: Colors.white,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget enigmaDes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 32, right: 32),
      child: Text(
        AppLocalizations.instance.translate('description_text'),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.grey,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
