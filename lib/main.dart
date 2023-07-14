import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/views/login_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
          )),
          scaffoldBackgroundColor: const CustomColors().beige),
      debugShowCheckedModeBanner: false,
      home: const LoginView(),
    );
  }
}
