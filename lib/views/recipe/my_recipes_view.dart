import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_groovy_recipes/components/recipe/recipes_list_view.dart';
import 'package:my_groovy_recipes/components/textfields/search_textfield.dart';
import 'package:my_groovy_recipes/constants/routes.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/cloud/cloud_recipe.dart';
import 'package:my_groovy_recipes/services/cloud/recipe_service.dart';
import 'package:my_groovy_recipes/utils/dialogs/logout_dialog.dart';
import 'package:my_groovy_recipes/views/recipe/recipe_view.dart';

class MyRecipesView extends StatefulWidget {
  const MyRecipesView({super.key});

  @override
  State<MyRecipesView> createState() => _MyRecipesViewState();
}

class _MyRecipesViewState extends State<MyRecipesView> {
  late final RecipeService _recipesService;
  late final TextEditingController _searchController;
  List<CloudRecipe> _filteredRecipes = <CloudRecipe>[];
  String get userId => FirebaseAuth.instance.currentUser!.uid;
  String _searchText = '';
  bool closeSearch = true;

  @override
  void initState() {
    _recipesService = RecipeService();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // listen to user input changes in search bar
  void _onSearchTextChanged() {
    final searchText = _searchController.text;
    if (searchText != _searchText) {
      setState(() {
        _searchText = searchText;
      });
    }
  }

  // show or hide search bar
  void _toggleSearch() {
    setState(() {
      closeSearch = !closeSearch;
      if (closeSearch == true) {
        _searchText = "";
      }
    });
  }

  // clear search text and hide search bar
  void _clearSearch() {
    setState(() {
      _searchText = "";
      _searchController.clear();
      closeSearch = true;
    });
  }

  // sign out the user
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: closeSearch ? defaultPadding : 0,
        leading: closeSearch
            ? null
            : IconButton(
                icon: const Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.black,
                ),
                onPressed: () {
                  _clearSearch();
                },
              ),
        title: closeSearch
            ? const Text("My Groovy Recipes")
            : Padding(
                padding: const EdgeInsets.only(right: defaultPadding),
                child: SearchTextField(
                  controller: _searchController,
                  autofocus: true,
                ),
              ),
        actions: closeSearch
            ? [
                IconButton(
                    onPressed: _toggleSearch,
                    icon: const Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      color: Colors.black,
                    )),
                IconButton(
                    onPressed: () async {
                      // show a modal to the user asking if he or she wants to sign out
                      final confirmSignOut = await showSignOutDialog(context);
                      if (confirmSignOut) {
                        // user confirmed to sign out
                        signOut();
                      }
                    },
                    icon: const Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.black,
                    )),
              ]
            : [],
      ),

      // create / add a new recipe button
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: const CustomColors().yellow,
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.black, width: 2, style: BorderStyle.solid)),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(createOrEditRecipeRoute)
                .then((_) => _clearSearch());
          },
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          child: const Icon(
            FontAwesomeIcons.plus,
            color: Colors.black,
          ),
        ),
      ),
      // body
      body: Column(
        // physics: const BouncingScrollPhysics(),
        children: [
          Expanded(
            child: StreamBuilder(
              // listen to changes in the user's recipes and update UI if changes are found
              stream: _recipesService.allRecipes(ownerUserId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allRecipes = snapshot.data as Iterable<CloudRecipe>;

                      if (allRecipes.isEmpty) {
                        // user has not created any recipes yet
                        return const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text(
                              "You don't have any recipes yet. To add a new recipe, simply click the yellow plus icon located in the bottom-right corner!"),
                        );
                      }

                      // filter recipes based on the search query
                      _filteredRecipes = allRecipes.where((recipe) {
                        final lowercaseQuery =
                            _searchController.text.toLowerCase();

                        // check if the recipe name contains the search query
                        if (recipe.name
                            .toLowerCase()
                            .contains(lowercaseQuery)) {
                          return true;
                        }

                        // check if any of the recipe tags contain the search query
                        for (final tag in recipe.tags) {
                          if (tag.toLowerCase().contains(lowercaseQuery)) {
                            return true;
                          }
                        }

                        return false;
                      }).toList();

                      if (_filteredRecipes.isEmpty) {
                        // did not find any recipes with that search text
                        return const Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Text("Oops! No matching recipes found."),
                        );
                      }

                      // render all recipes
                      return RecipesListView(
                        recipes: _filteredRecipes,
                        onTap: (recipe) {
                          final recipeData = CloudRecipe(
                            documentId: recipe.documentId,
                            image: recipe.image,
                            ownerUserId: recipe.ownerUserId,
                            steps: recipe.steps,
                            name: recipe.name,
                            portions: recipe.portions,
                            tags: recipe.tags,
                            ingredients: recipe.ingredients,
                            description: recipe.description,
                          );

                          // navigate the user to the RecipeView page

                          // navigate to RecipeView with the tapped recipe data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeView(recipe: recipeData),
                            ),
                          ).then((_) => _clearSearch());
                        },
                      );
                    } else {
                      return const Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  default:
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
