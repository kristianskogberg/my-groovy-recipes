import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_groovy_recipes/components/recipe/tag_list.dart';
import 'package:my_groovy_recipes/components/titles/heading.dart';
import 'package:my_groovy_recipes/constants/image_paths.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/cloud/cloud_recipe.dart';
import 'package:transparent_image/transparent_image.dart';

const double imageSize = 120;

typedef RecipeCallback = void Function(CloudRecipe recipe);

class RecipesListView extends StatelessWidget {
  final Iterable<CloudRecipe> recipes;
  final RecipeCallback onTap;
  const RecipesListView({
    super.key,
    required this.recipes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: recipes.length,
      padding: const EdgeInsets.all(defaultPadding),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        // gap between list items
        return const SizedBox(height: 24);
      },
      itemBuilder: (context, index) {
        // get the current recipe and render its contents
        final recipe = recipes.elementAt(index);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(defaultBorderRadius),
            boxShadow: const [
              // extra bottom border
              BoxShadow(
                color: Colors.black,
                offset: Offset(0, 4),
                blurRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              onTap(recipe);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(defaultBorderRadius),
                        bottomLeft: Radius.circular(defaultBorderRadius)),
                    child: recipe.image.contains("asset")
                        ?
                        // recipe image is one of the provided asset images
                        SizedBox(
                            width: imageSize,
                            height: imageSize,
                            child: Padding(
                              padding: const EdgeInsets.all(defaultPadding),
                              child: Image.asset(
                                recipe.image,
                                width: imageSize,
                                height: imageSize,
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        :
                        // recipe image is one of the uploaded images
                        SizedBox(
                            width: imageSize,
                            height: imageSize,
                            child: Stack(
                              children: <Widget>[
                                const Center(
                                    child: CircularProgressIndicator()),
                                Center(
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: recipe.image,
                                    width: imageSize,
                                    height: imageSize,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )),

                // vertical separator line
                const SizedBox(
                  width: 2,
                  height: imageSize,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: Colors.black),
                  ),
                ),
                // right side
                Expanded(
                  child: SizedBox(
                    height: imageSize,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: HeadingText(
                            text: recipe.name,
                            maxLines: 1,
                          ),
                        ),
                        if (recipe.tags.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Text(
                              "No tags available",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        // tags
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          scrollDirection: Axis.horizontal,
                          child: TagList(tags: recipe.tags),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
