import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/components/buttons/full_width_textbutton.dart';
import 'package:my_groovy_recipes/components/buttons/rounded_textbutton_icon.dart';
import 'package:my_groovy_recipes/components/recipe/portions_calculator.dart';
import 'package:my_groovy_recipes/components/recipe/tag.dart';
import 'package:my_groovy_recipes/components/textfields/rounded_textfield.dart';
import 'package:my_groovy_recipes/components/titles/subheading.dart';
import 'package:my_groovy_recipes/constants/image_paths.dart';
import 'package:my_groovy_recipes/constants/styling.dart';
import 'package:my_groovy_recipes/services/cloud/cloud_recipe.dart';
import 'package:my_groovy_recipes/services/cloud/ingredient.dart';
import 'package:my_groovy_recipes/services/cloud/recipe_service.dart';
import 'package:my_groovy_recipes/utils/dialogs/discard_changes_dialog.dart';
import 'package:my_groovy_recipes/utils/dialogs/error_dialog.dart';
import 'package:my_groovy_recipes/utils/dialogs/image_selection_dialog.dart';

const int noIngredientSelected = -1;

class CreateOrEditRecipeView extends StatefulWidget {
  final CloudRecipe? recipe;
  const CreateOrEditRecipeView({
    super.key,
    this.recipe,
  });

  @override
  State<CreateOrEditRecipeView> createState() => _CreateOrEditRecipeViewState();
}

class _CreateOrEditRecipeViewState extends State<CreateOrEditRecipeView> {
  String appBarTitle = "New Recipe";
  late final RecipeService _recipeService;
  late final TextEditingController _name;
  late final TextEditingController _steps;
  late final TextEditingController _ingredientName;
  late final TextEditingController _ingredientAmount;
  late final TextEditingController _tagName;
  late final TextEditingController _description;
  List<Ingredient> _ingredients = List.empty(growable: true);
  List<String> _tags = List.empty(growable: true);
  final FocusNode _ingredientAmountFocusNode = FocusNode();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  String _ingredientErrorMessage = "";
  String _imageUrl = recipePlaceholderImagePath;
  bool _isLoading = false;

  late final String _oldImageUrl;

  int _selectedIngredientIndex = noIngredientSelected;

  int _portions = 1;

  void incrementPortions() {
    if (_isLoading == true) {
      return;
    }
    setState(() {
      if (_portions < 99) {
        _portions++;
      }
    });
  }

  void decrementPortions() {
    if (_isLoading == true) {
      return;
    }
    setState(() {
      if (_portions > 1) {
        _portions--;
      }
    });
  }

  @override
  void initState() {
    _recipeService = RecipeService();
    _name = TextEditingController();
    _steps = TextEditingController();
    _ingredientName = TextEditingController();
    _ingredientAmount = TextEditingController();
    _tagName = TextEditingController();
    _description = TextEditingController();

    if (widget.recipe != null) {
      // user is editing a recipe, fill in data
      appBarTitle = "Edit Recipe";
      _name.text = widget.recipe!.name;
      _steps.text = widget.recipe!.steps;
      _description.text = widget.recipe!.description;
      _portions = widget.recipe!.portions;
      _ingredients = widget.recipe!.ingredients;
      _tags = widget.recipe!.tags;
      _imageUrl = widget.recipe!.image;
      _oldImageUrl = widget.recipe!.image;
    }
    super.initState();
  }

  void _addTag(String tag) {
    if (tag != "" && _tags.length < 10) {
      setState(() {
        _tags.add(tag);
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future selectImage() async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );
    // return if the user did not select an image
    if (selectedImage == null) return null;

    // user selected an image from his or hers device
    setState(() {
      _image = selectedImage;
    });
  }

  // add or update selected ingredient
  void addOrUpdateIngredient() {
    if (_ingredientName.text.isEmpty || _ingredientAmount.text.isEmpty) {
      setState(() {
        _ingredientErrorMessage = "Please fill in both fields";
      });
      return;
    }
    setState(() {
      _ingredientErrorMessage = "";
    });
    String ingredientName = _ingredientName.text;
    double ingredientAmount = double.parse(_ingredientAmount.text);
    if (ingredientName.isNotEmpty) {
      // add new ingredient to the list or update it
      setState(() {
        if (_selectedIngredientIndex != noIngredientSelected) {
          // user has selected an ingredient, so update it
          _ingredients[_selectedIngredientIndex].amount = ingredientAmount;
          _ingredients[_selectedIngredientIndex].name = ingredientName;
          // after updating the ingredient, set the index back to -1 (or nothing selecyted)
          _selectedIngredientIndex = noIngredientSelected;
        } else {
          // add new ingredient
          _ingredients
              .add(Ingredient(amount: ingredientAmount, name: ingredientName));
        }
        // clear ingredient amount and name fields
        _ingredientAmount.clear();
        _ingredientName.clear();
        // focus back to the ingredient amount text field
        _ingredientAmountFocusNode.requestFocus();
      });
    }
  }

  Future<void> chooseImage() async {
    if (_isLoading) return;

    Map<String, dynamic>? imageSelect = await showImageSelectionDialog(context);
    if (imageSelect != null) {
      String? selectedImageAsset = imageSelect['selectedImageAsset'];
      XFile? selectedImageFile = imageSelect['selectedImageFromDevice'];
      if (selectedImageFile != null) {
        // user selected an image from his or hers device
        setState(() {
          _image = selectedImageFile;
        });
      }
      if (selectedImageAsset != null) {
        // user selected one of the provided image assets
        setState(() {
          _imageUrl = selectedImageAsset;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            titleSpacing: 0,
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.black,
              ),
              onPressed: () async {
                if (_name.text.isEmpty &&
                    _description.text.isEmpty &&
                    _portions == 1 &&
                    _ingredients.isEmpty &&
                    _steps.text.isEmpty &&
                    _tags.isEmpty &&
                    _image == null) {
                  // the user has not changed or modified any of the default fields,
                  // so navigate back to MyRecipesView
                  Navigator.of(context)
                      .popUntil((myRecipesRoute) => myRecipesRoute.isFirst);
                  return;
                }

                final exit = await showExitWithoutSavingChangesDialog(context);
                if (exit == true && context.mounted) {
                  // navigate back to MyRecipesView
                  Navigator.of(context)
                      .popUntil((myRecipesRoute) => myRecipesRoute.isFirst);
                }
              },
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(defaultBorderRadius))),
                child:
                    // recipe image
                    Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: Image.file(
                              File(_image!.path),
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            child: Stack(
                              children: [
                                Container(
                                  height: 250,
                                  color: Colors.white,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                                Center(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_imageUrl.contains("asset")) ...[
                                      // recipe contains a provided asset image, display it
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Image.asset(_imageUrl,
                                              height: 250,
                                              width: double.infinity,
                                              fit: BoxFit.contain),
                                        ),
                                      ),
                                    ] else if (_imageUrl ==
                                        recipePlaceholderImagePath) ...[
                                      // recipe does not contain any images, display placeholder
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Image.asset(
                                            recipePlaceholderImagePath,
                                            height: 250,
                                            width: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ] else ...[
                                      // recipe contains an uploaded image from the user's device, display it
                                      Expanded(
                                        child: CachedNetworkImage(
                                          height: 250,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          imageUrl: _imageUrl,
                                          placeholder: (context, url) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          },
                                          errorWidget: (context, url, error) {
                                            return Padding(
                                              padding: const EdgeInsets.all(
                                                  defaultPadding),
                                              child: Image.asset(
                                                  imageNotFoundPath),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                )),
                              ],
                            ),
                          ),

                    // choose an image button
                    Center(
                      child: RoundedTextIconButton(
                          icon: const Icon(
                            FontAwesomeIcons.image,
                            color: Colors.black,
                          ),
                          onPressed: chooseImage,
                          text: "Choose an Image"),
                    ),
                    _image != null || _imageUrl != recipePlaceholderImagePath
                        ?
                        // remove image button
                        Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton(
                              icon: const Icon(
                                FontAwesomeIcons.xmark,
                                color: Colors.black,
                              ),
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      // remove image and set it to the placeholder image
                                      setState(() {
                                        _image = null;
                                        _imageUrl = recipePlaceholderImagePath;
                                      });
                                    },
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // name subheading
                    const SubheadingText(text: "Name*"),

                    // recipe name text field
                    RoundedTextField(
                      hint: "Name of the recipe...",
                      controller: _name,
                      enabled: _isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Your recipe is missing a name!";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // description subheading
                    const SubheadingText(text: "Description"),

                    // recipe description text field
                    RoundedTextField(
                      hint: "Description...",
                      enabled: _isLoading,
                      controller: _description,
                      maxLines: 3,
                    ),

                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // portions subheading
                    const SubheadingText(text: "Portions*"),

                    const SizedBox(width: 8.0),

                    // portions calculator
                    PortionsCalculator(
                        portions: _portions,
                        onDecrementPressed: decrementPortions,
                        onIncrementPressed: incrementPortions),

                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // ingredients subheading
                    const SubheadingText(text: "Ingredients*"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        border: Border.all(
                            width: 2,
                            color: (_ingredients.isEmpty &&
                                    _ingredientErrorMessage != "")
                                ? Colors.red
                                : Colors.black),
                      ),
                      child: Row(
                        children: [
                          // ingredient amount text field
                          Expanded(
                            flex: 2,
                            child: RoundedTextField(
                              hint: "Amount",
                              focusNode: _ingredientAmountFocusNode,
                              enabled: _isLoading,
                              controller: _ingredientAmount,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(defaultBorderRadius),
                                  bottomLeft:
                                      Radius.circular(defaultBorderRadius),
                                  topRight: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0)),
                              isNumber: true,
                              borderWidth: 0.0,
                            ),
                          ),
                          // vertical separator line between amount and name
                          SizedBox(
                            width: 2,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: (_ingredients.isEmpty &&
                                          _ingredientErrorMessage != "")
                                      ? Colors.red
                                      : Colors.black),
                            ),
                          ),
                          // ingredient name text field
                          Expanded(
                            flex: 5,
                            child: RoundedTextField(
                              hint: "Name...",
                              controller: _ingredientName,
                              enabled: _isLoading,
                              borderRadius: BorderRadius.zero,
                              borderWidth: 0,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: (_ingredients.isEmpty &&
                                          _ingredientErrorMessage != "")
                                      ? Colors.red
                                      : Colors.black),
                            ),
                          ),
                          // add ingredient button
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const CustomColors().yellow,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(defaultBorderRadius),
                                bottomRight:
                                    Radius.circular(defaultBorderRadius),
                              ),
                            ),
                            child: IconButton(
                                onPressed: _isLoading == true
                                    ? null
                                    : addOrUpdateIngredient,
                                icon: Icon(
                                  _selectedIngredientIndex ==
                                          noIngredientSelected
                                      ? FontAwesomeIcons.plus
                                      : FontAwesomeIcons.check,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                    ),
                    // possible ingredient error message
                    if (_ingredientErrorMessage != "" || _ingredients.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8, bottom: 8, right: 16, left: 16),
                        child: Text(
                          _ingredientErrorMessage,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),

                    // list of added ingredients
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ingredients.length,
                      itemBuilder: (context, index) => getIngredientRow(index),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                        );
                      },
                    ),

                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // steps subheading
                    const SubheadingText(text: "Steps*"),

                    // steps text field
                    RoundedTextField(
                      hint: "Steps...",
                      enabled: _isLoading,
                      controller: _steps,
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Your recipe is missing steps on how to produce it!';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: defaultPadding,
                    ),

                    // tags text field
                    const SubheadingText(text: "Tags"),

                    // recipe's tags section
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                        border: Border.all(width: 2.0, color: Colors.black),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: RoundedTextField(
                              hint: "Tag name...",
                              enabled: _isLoading,
                              controller: _tagName,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(defaultBorderRadius),
                                  bottomLeft:
                                      Radius.circular(defaultBorderRadius),
                                  topRight: Radius.circular(0.0),
                                  bottomRight: Radius.circular(0.0)),
                              borderWidth: 0.0,
                            ),
                          ),
                          const SizedBox(
                            width: 2,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.black),
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const CustomColors().yellow,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(defaultBorderRadius),
                                bottomRight:
                                    Radius.circular(defaultBorderRadius),
                              ),
                            ),
                            child: IconButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                        // add a new tag
                                        String tag = _tagName.text;
                                        _addTag(tag);
                                        _tagName.clear();
                                      },
                                icon: const Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.black,
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: defaultPadding),

                    // tags
                    Wrap(
                      spacing: 8,
                      runSpacing: 16,
                      children: _tags.map((tag) {
                        return Tag(
                          tag: tag,
                          onTap: () {
                            if (_isLoading) return;
                            // remove a tag
                            _removeTag(tag);
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: largePadding),

                    // save button
                    FullWidthTextButton(
                        isLoading: _isLoading,
                        onPressed: () async {
                          // dismiss keyboard
                          FocusManager.instance.primaryFocus?.unfocus();
                          // validate inputs
                          _submitForm();
                        },
                        text: widget.recipe == null
                            ? "Save Recipe"
                            : "Save Changes"),
                    const SizedBox(height: largePadding),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

// is called when user presses save (changes) button
  Future _submitForm() async {
    final form = _formKey.currentState;

    if (_ingredients.isEmpty) {
      setState(() {
        _ingredientErrorMessage = "Your recipe is missing ingredients!";
      });
    } else {
      setState(() {
        _ingredientErrorMessage = "";
      });
    }
    if (form != null && form.validate()) {
      if (_ingredientErrorMessage != "") return;
      // Form is valid

      final currentUser = FirebaseAuth.instance.currentUser!;
      final userId = currentUser.uid;

      // show loading animation
      setState(() {
        _isLoading = true;
      });

      // try to save or update recipe
      try {
        if (widget.recipe == null) {
          // user is creating a new recipe, save it

          await _recipeService.addNewRecipe(
            ownerUserId: userId,
            name: _name.text,
            steps: _steps.text,
            portions: _portions,
            description: _description.text,
            ingredients: _ingredients,
            image: _image,
            imageUrl: _imageUrl,
            tags: _tags,
          );
        } else {
          // user is updating a recipe, save changes

          await _recipeService.updateRecipe(
            documentId: widget.recipe!.documentId,
            ownerUserId: userId,
            name: _name.text,
            steps: _steps.text,
            portions: _portions,
            description: _description.text,
            ingredients: _ingredients,
            image: _image,
            tags: _tags,
            oldImageUrl: _oldImageUrl,
            newImageUrl:
                _image == null ? _imageUrl : recipePlaceholderImagePath,
          );
        }
      } on FirebaseAuthException catch (e) {
        // firebase error
        Logger().e(e);
        // dismiss loading
        setState(() {
          _isLoading = false;
        });
        // show error message to the user
        showErrorDialog(context,
            "We encountered the following error while talking with our database: ${e.code.toString()}");
      } catch (e) {
        // generic error
        Logger().e(e);
        // dismiss loading
        setState(() {
          _isLoading = false;
        });
        // show error message to the user
        showErrorDialog(context,
            "We encountered an unknown error while talking with our database. Please try again later.");
      }

      // navigate to MyRecipesView after saving the recipe successfully
      if (context.mounted) {
        Navigator.of(context)
            .popUntil((myRecipesRoute) => myRecipesRoute.isFirst);
      }
    }
  }

  Widget getIngredientRow(int index) {
    return Column(
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          contentPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
          title: Row(
            children: [
              Text(_ingredients[index].amount.toStringAsFixed(
                  _ingredients[index].amount.truncateToDouble() ==
                          _ingredients[index].amount
                      ? 0
                      : 2)),
              const SizedBox(
                width: 8.0,
              ),
              Text(_ingredients[index].name)
            ],
          ),
          trailing: SizedBox(
            width: 70,
            child: Row(children: [
              InkWell(
                  onTap: _isLoading == true
                      ? null
                      : () {
                          // remove the selected ingredient
                          setState(() {
                            _ingredients.removeAt(index);
                          });
                        },
                  child: const Icon(FontAwesomeIcons.trashCan,
                      color: Colors.black)),
              const SizedBox(width: 16),
              InkWell(
                  onTap: _isLoading == true
                      ? null
                      : () {
                          // save the changes for the selected ingredient
                          setState(() {
                            _selectedIngredientIndex = index;
                          });
                          _ingredientAmount.text =
                              _ingredients[index].amount.toString();
                          _ingredientName.text = _ingredients[index].name;
                        },
                  child: const Icon(FontAwesomeIcons.penToSquare,
                      color: Colors.black)),
            ]),
          ),
        ),
      ],
    );
  }
}
