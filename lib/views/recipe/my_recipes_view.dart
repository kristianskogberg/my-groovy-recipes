import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyRecipesView extends StatefulWidget {
  MyRecipesView({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  @override
  State<MyRecipesView> createState() => _MyRecipesViewState();
}

class _MyRecipesViewState extends State<MyRecipesView> {
  // sign out the user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Groovy Recipes"), actions: [
        IconButton(
            onPressed: signOut,
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            )),
      ]),
    );
  }
}
