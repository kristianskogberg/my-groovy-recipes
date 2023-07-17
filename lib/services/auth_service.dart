import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // singleton pattern
  static final AuthService _shared = AuthService._sharedInstance();
  AuthService._sharedInstance();
  factory AuthService() => _shared;

  // google sign in
  Future signInWithGoogle({required BuildContext context}) async {
    // begin the google sign in process where the user can choose his or hers google account
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // user cancelled the google sign in process

      return;
    }

    // get auth details from the user
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // create a credential for the user
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // sign the user in
    final user = await FirebaseAuth.instance.signInWithCredential(credential);

    return user;
  }
}
