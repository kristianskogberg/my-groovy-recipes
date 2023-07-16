import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/components/misc/checkbox.dart';
import 'package:my_groovy_recipes/services/cloud/ingredient.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final double portions;

  const IngredientList(
      {super.key, required this.ingredients, required this.portions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: ingredients.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final item = ingredients[index];
            final name = item.name;
            final amount = item.amount * portions;
            final amountRounded = amount
                .toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2);

            return ListTile(
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CheckboxWidget(),
                  Text('$amountRounded $name'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
