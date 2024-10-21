import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/constants/config.dart';

class RecipeLimitView extends StatefulWidget {
  const RecipeLimitView({super.key});

  @override
  State<RecipeLimitView> createState() => _RecipeLimitViewState();
}

class _RecipeLimitViewState extends State<RecipeLimitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Limit Reached"),
      ),
      body: const Center(
        child: Text(
          "You have reached the limit of ${Config.recipeLimit} recipes. Please delete an existing recipe to create a new one.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
