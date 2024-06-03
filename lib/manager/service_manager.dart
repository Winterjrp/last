class ServiceManager {
  static const bool isRealService = true;
}

class ApiLinkManager {
  static const String baseUrl = "http://10.3.133.119:3000";

  // Auth Endpoints
  static String login() => "$baseUrl/api/auth/login";
  static String register() => "$baseUrl/api/auth/register";

  //admin

  //petType
  static String getAllPetTypeInfo() =>
      "$baseUrl/api/animalType/admin-allAnimalType";
  static String addPetTypeInfo() => "$baseUrl/api/animalType/add-new";
  static String editPetTypeInfo() => "$baseUrl/api/animalType/update";
  static String deletePetTypeInfo() => "$baseUrl/api/animalType/delete/";

  //ingredient
  static String getAllIngredient() => "$baseUrl/api/ingredients";
  static String addIngredientInfo() => "$baseUrl/api/ingredients/add-new";
  static String editIngredientInfo() => "$baseUrl/api/ingredients/update";
  static String deleteIngredientInfo() => "$baseUrl/api/ingredients/delete/";

  //recipe
  static String getAllRecipe() => "$baseUrl/api/petRecipes/admin-allPetRecipes";
  static String addRecipe() => "$baseUrl/api/petRecipes/add-new";
  static String editRecipeInfo() => "$baseUrl/api/petRecipes/update";
  static String deleteRecipeInfo() => "$baseUrl/api/petRecipes/delete/";

  //adminHomeData
  static String getAdminHomeData() => "$baseUrl/api/adminHome/totalAmount";

  //searchRecipe
  static String adminSearchRecipe() =>
      "$baseUrl/api/searchPetRecipes/admin-getPetRecipes";
  // static String searchRecipe() => "$baseUrl/api/searchPetRecipes/getPetRecipes";
  static String normalUserSearchRecipe() =>
      "$baseUrl/api/searchPetRecipes/user-getPetRecipes";
  static String searchRecipeFromAlgorithm() =>
      "$baseUrl/api/searchPetRecipes/getPetRecipes/algorithm";

  // User Endpoints
  // static String getUserProfile(String userId) => "$baseUrl/users/$userId";
  // static String updateUserProfile(String userId) => "$baseUrl/users/$userId";

  // Other Endpoints
  // static String getPosts() => "$baseUrl/posts";
  // static String createPost() => "$baseUrl/posts";
  // static String getComments(String postId) => "$baseUrl/posts/$postId/comments";

// Add more endpoints as needed

// You can also include API versioning in the URLs if needed
// static String getUserProfile(String userId) => "$baseUrl/v1/users/$userId";
}
