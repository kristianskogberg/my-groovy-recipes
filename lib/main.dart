import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/views/auth/auth_view.dart';
import 'package:my_groovy_recipes/views/auth/verify_email_view.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final _navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'My Groovy Recipes',
      theme: ThemeData(
          primaryColor: const CustomColors().beige,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: const CustomColors().beige,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Colors.brown,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          scaffoldBackgroundColor: const CustomColors().beige),
      debugShowCheckedModeBanner: false,
      home: const MainView(),
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // loading...
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            // user is logged in
            return const VerifyEmailView();
          } else {
            // user is not logged in
            return const AuthView();
          }
        },
      ),
    );
  }
}
