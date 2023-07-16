import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_groovy_recipes/services/cloud/field_names.dart';
import 'package:my_groovy_recipes/services/cloud/ingredient.dart';

@immutable
class CloudRecipe {
  final String documentId;
  final String ownerUserId;
  final String steps;
  final String name;
  final int portions;
  final List<Ingredient> ingredients;
  final List<String> tags;
  final String description;
  final String image;

  const CloudRecipe({
    required this.documentId,
    required this.ownerUserId,
    required this.steps,
    required this.name,
    required this.portions,
    required this.ingredients,
    required this.description,
    required this.tags,
    required this.image,
  });

  CloudRecipe.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        image = snapshot.data()[imageFieldName] as String,
        steps = snapshot.data()[stepsFieldName] as String,
        name = snapshot.data()[nameFieldName] as String,
        portions = snapshot.data()[portionsFieldName] as int,
        tags = List<String>.from(snapshot.data()[tagsFieldName]),
        description = snapshot.data()[descriptionFieldName] as String,
        ingredients = (snapshot.data()[ingredientsFieldName] as List<dynamic>)
            .map((e) => Ingredient.fromJson(e))
            .toList();
}
