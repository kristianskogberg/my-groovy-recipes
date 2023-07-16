class RecipeServiceException implements Exception {
  const RecipeServiceException();
}

class CouldNotCreateRecipeException extends RecipeServiceException {}

class CouldNotGetAllRecipesException extends RecipeServiceException {}

class CouldNotUpdateRecipeException extends RecipeServiceException {}

class CouldNotDeleteRecipeException extends RecipeServiceException {}

class CouldNotUploadRecipeImageException extends RecipeServiceException {}
