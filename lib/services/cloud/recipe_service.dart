import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:my_groovy_recipes/services/cloud/cloud_recipe.dart';
import 'package:my_groovy_recipes/services/cloud/field_names.dart';
import 'package:my_groovy_recipes/services/cloud/ingredient.dart';
import 'package:my_groovy_recipes/services/cloud/recipe_service_exceptions.dart';
import 'package:uuid/uuid.dart';

class RecipeService {
  final recipes = FirebaseFirestore.instance.collection("recipes");

  // singleton pattern
  static final RecipeService _shared = RecipeService._sharedInstance();
  RecipeService._sharedInstance();
  factory RecipeService() => _shared;

  // delete recipe from firebase
  Future<void> deleteRecipe({
    required String documentId,
    required String imageUrl,
  }) async {
    // delete the recipe image as well if it exists
    if (imageUrl != "") {
      await deleteImage(imageUrl);
    }
    try {
      await recipes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteRecipeException();
    }
  }

  // update recipe data in firebase
  Future<void> updateRecipe({
    XFile? image,
    required String oldImageUrl,
    required String newImageUrl,
    required String documentId,
    required String ownerUserId,
    required String name,
    required String steps,
    required int portions,
    required String description,
    required List<Ingredient> ingredients,
    required List<String> tags,
  }) async {
    String uploadedImageUrl = "";

    // upload image if the user has selected an image
    if (image != null) {
      uploadedImageUrl = await uploadImage(image);
    }

    // delete old image if the user had previously uploaded an image but has now removed it from the UI
    // or the user has selected a new image
    if ((newImageUrl == "" && oldImageUrl != "")) {
      await deleteImage(oldImageUrl);
    }

    // finally update recipe data
    try {
      await recipes.doc(documentId).update({
        ownerUserIdFieldName: ownerUserId,
        nameFieldName: name,
        imageFieldName: image != null ? uploadedImageUrl : newImageUrl,
        stepsFieldName: steps,
        descriptionFieldName: description,
        portionsFieldName: portions,
        ingredientsFieldName: ingredients.map((e) => e.toJson()).toList(),
        tagsFieldName: tags.toList(),
      });
    } catch (e) {
      throw CouldNotUpdateRecipeException();
    }
  }

  // upload image that the user selected to firebase storage
  Future<String> uploadImage(XFile image) async {
    try {
      final randomId = const Uuid().v4();
      final path = "recipe_images/$randomId.png";
      final ref = FirebaseStorage.instance.ref().child(path);

      final file = File(image.path);
      UploadTask uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() => null);

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw CouldNotUploadRecipeImageException();
    }
  }

  // delete image from firebase storage
  Future<void> deleteImage(String downloadUrl) async {
    try {
      Reference storageReference =
          FirebaseStorage.instance.refFromURL(downloadUrl);
      await storageReference.delete();
      Logger().d('Image deleted successfully');
    } catch (e) {
      Logger().e('Error deleting image: $e');
    }
  }

  // add new recipe to firestore
  Future<void> addNewRecipe({
    XFile? image,
    required String ownerUserId,
    required String name,
    required String steps,
    required int portions,
    required String description,
    required List<Ingredient> ingredients,
    required List<String> tags,
  }) async {
    String uploadedImageUrl = "";

    // upload image as well if it exists
    if (image != null) {
      uploadedImageUrl = await uploadImage(image);
    }
    // upload recipe data
    try {
      await recipes.add({
        ownerUserIdFieldName: ownerUserId,
        imageFieldName: uploadedImageUrl,
        nameFieldName: name,
        stepsFieldName: steps,
        descriptionFieldName: description,
        portionsFieldName: portions,
        ingredientsFieldName: ingredients.map((e) => e.toJson()).toList(),
        tagsFieldName: tags.toList(),
      });
    } catch (e) {
      throw CouldNotCreateRecipeException();
    }
  }

  // return all of user's recipes from firestore
  Stream<Iterable<CloudRecipe>> allRecipes({required String ownerUserId}) {
    return recipes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudRecipe.fromSnapshot(doc)));
  }
}
