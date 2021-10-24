import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignInAccount currentUser;
String imageUrl;
String name;
String userId;

final GoogleSignIn googleSignIn = GoogleSignIn();
User user = _auth.currentUser;

Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);

  final User user = authResult.user;

  assert(user.uid != null);
  userId = user.uid;
  imageUrl = user.photoURL;
  name = user.displayName;
}

Future<void> checkingCurrentUser(BuildContext context) async {
  googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    currentUser = account;
    userId = user.uid;

    if (currentUser != null) {
      imageUrl = currentUser.photoUrl;
      name = currentUser.displayName;
      Navigator.pushReplacementNamed(context, '/map');
    } else {
      getCurrentUser(context);
    }
  });
  googleSignIn.signInSilently();
}

Future<void> signOutWithGoogle(BuildContext context) async {
  _auth.signOut().then((value) {
    googleSignIn.signOut();
    Navigator.pushReplacementNamed(context, 'signIn');
  });
}

Future<void> getCurrentUser(BuildContext context) async {
  user = _auth.currentUser;
  if (user == null) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, '/signIn');
    });
  }
}
