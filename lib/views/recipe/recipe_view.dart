import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_groovy_recipes/components/recipe/ingredients_list.dart';
import 'package:my_groovy_recipes/components/recipe/portions_calculator.dart';
import 'package:my_groovy_recipes/components/recipe/tag_list.dart';
import 'package:my_groovy_recipes/components/titles/heading.dart';
import 'package:my_groovy_recipes/components/titles/subheading.dart';
import 'package:my_groovy_recipes/constants/image_paths.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/cloud/cloud_recipe.dart';
import 'package:my_groovy_recipes/services/cloud/recipe_service.dart';
import 'package:my_groovy_recipes/services/update_user_recipe_count.dart';
import 'package:my_groovy_recipes/utils/dialogs/delete_dialog.dart';
import 'package:my_groovy_recipes/views/recipe/create_or_edit_recipe_view.dart';

class RecipeView extends StatefulWidget {
  final CloudRecipe recipe; // Data received from the first view

  const RecipeView({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeView> createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  late final RecipeService _recipeService;
  int portionsInput = 1;
  double portionsMultiplier = 1;

  @override
  void initState() {
    _recipeService = RecipeService();
    portionsInput = widget.recipe.portions;
    super.initState();
  }

  void incrementPortions() {
    setState(() {
      if (portionsInput < 99) {
        portionsInput++;
        if (portionsInput > 0 && widget.recipe.portions > 0) {
          portionsMultiplier = (portionsInput - widget.recipe.portions) /
                  widget.recipe.portions +
              1;
        }
      }
    });
  }

  void decrementPortions() {
    setState(() {
      if (portionsInput > 1) {
        portionsInput--;
        if (portionsInput > 0 && widget.recipe.portions > 0) {
          portionsMultiplier = (portionsInput - widget.recipe.portions) /
                  widget.recipe.portions +
              1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.name),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  _recipeService.deleteRecipe(
                    documentId: widget.recipe.documentId,
                    imageUrl: widget.recipe.image,
                  );

                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId != null) {
                    // update user's recipe count
                    await updateRecipeCount(userId);
                  }

                  if (context.mounted) {
                    Navigator.of(context)
                        .popUntil((myRecipesRoute) => myRecipesRoute.isFirst);
                  }
                }
              },
              padding: const EdgeInsets.only(right: 0.0),
              icon: const Icon(
                FontAwesomeIcons.trashCan,
                color: Colors.black,
              )),
          IconButton(
              onPressed: () {
                // navigate to create/edit recipe view
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateOrEditRecipeView(recipe: widget.recipe),
                  ),
                );
              },
              padding: const EdgeInsets.only(right: 16.0),
              icon: const Icon(
                FontAwesomeIcons.penToSquare,
                color: Colors.black,
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        physics: const BouncingScrollPhysics(),
        child: Column(
          // padding: EdgeInsets.zero,
          //  shrinkWrap: true,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: const BorderRadius.all(
                      Radius.circular(defaultBorderRadius))),
              height: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                child: Center(
                  child: widget.recipe.image.contains("asset")
                      ?
                      // recipe image is one of the provided asset images
                      Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Image.asset(widget.recipe.image,
                                height: 250,
                                width: double.infinity,
                                fit: BoxFit.contain),
                          ),
                        )
                      :
                      // recipe image is one of the uploaded images
                      CachedNetworkImage(
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          imageUrl: widget.recipe.image,
                          placeholder: (context, url) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          errorWidget: (context, url, error) {
                            return Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Image.asset(imageNotFoundPath),
                            );
                          },
                        ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeadingText(text: widget.recipe.name),
                if (widget.recipe.description == "") ...[
                  const Text(
                    "No description available",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: defaultPadding)
                ] else ...[
                  Column(
                    children: [
                      Text(widget.recipe.description),
                      const SizedBox(height: defaultPadding),
                    ],
                  ),
                ],
                TagList(tags: widget.recipe.tags),
                Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubheadingText(
                        text:
                            "Ingredients (${widget.recipe.ingredients.length.toString()})"),
                    PortionsCalculator(
                        portions: portionsInput,
                        onDecrementPressed: decrementPortions,
                        onIncrementPressed: incrementPortions),
                  ],
                ),
                IngredientList(
                  ingredients: widget.recipe.ingredients,
                  portions: portionsMultiplier,
                ),
                const SubheadingText(text: "Steps"),
                Padding(
                  padding: const EdgeInsets.only(
                      top: defaultPadding, bottom: defaultPadding),
                  child: Text(widget.recipe.steps),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
