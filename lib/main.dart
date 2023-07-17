import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/routes.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/views/auth/auth_view.dart';
import 'package:my_groovy_recipes/views/auth/verify_email_view.dart';
import 'package:my_groovy_recipes/views/recipe/create_or_edit_recipe_view.dart';
import 'package:my_groovy_recipes/views/recipe/my_recipes_view.dart';
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
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.black,
          ),
          //primarySwatch: Colors.black,
          primaryColor: const CustomColors().beige,
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: const CustomColors().beige,
            shape:
                const Border(bottom: BorderSide(color: Colors.black, width: 2)),
          ),
          textTheme: Theme.of(context).textTheme.copyWith(
                titleLarge: const TextStyle(
                  // for example app bar title style
                  fontWeight: FontWeight.normal,
                ),
              ),
          dialogTheme: const DialogTheme(
            elevation: 0,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: const CustomColors().yellow,
            selectionHandleColor: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          scaffoldBackgroundColor: const CustomColors().beige),
      debugShowCheckedModeBanner: false,
      home: const MainView(),
      routes: {
        myRecipesRoute: (context) => const MyRecipesView(),
        createOrEditRecipeRoute: (context) => const CreateOrEditRecipeView(),
      },
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
