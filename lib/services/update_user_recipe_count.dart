import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

Future<void> updateRecipeCount(String uid) async {
  try {
    // Query the recipes collection for the current user's recipes
    final QuerySnapshot recipesSnapshot = await FirebaseFirestore.instance
        .collection('recipes')
        .where('user_id', isEqualTo: uid) // Replace with your actual field name
        .get();

    // Count the number of recipes
    int recipeCount = recipesSnapshot.docs.length;

    // Update the user's recipe count
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'recipeCount': recipeCount,
    });

    Logger().d("Updated recipe count for user ID: $uid to $recipeCount.");
  } catch (e) {
    Logger().e("Failed to update recipe count: $e");
  }
}
