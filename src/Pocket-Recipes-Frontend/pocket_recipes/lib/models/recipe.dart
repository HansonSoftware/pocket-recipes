import 'dart:convert';
import 'package:pocket_recipes/utilities/http_handler.dart';

class Recipe {
  String id;
  String author;
  String title;
  String picture;
  List<dynamic> ingredients;
  List<dynamic> steps;
  bool hasPage;

  Recipe({
    required this.id,
    required this.author,
    required this.title,
    required this.picture,
    required this.ingredients,
    required this.steps,
    required this.hasPage,
  });

  static Recipe? fromDynamic(dynamic recipeData) {
    try {
      //TODO: Properly cast from dynamic to String
      return Recipe(
        id: recipeData["id"],
        author: "${recipeData["authors"]}",
        title: recipeData["name"],
        picture: recipeData["photoURL"],
        ingredients: recipeData["ingredientNames"],
        steps: recipeData["directions"],
        hasPage: true,
      );
    } catch (e, s) {
      print("Unable to convert `$recipeData` into a recipe!");
      print(e);
      print(s);
      return null;
    }
  }

  static Recipe fromNullableRecipe(Recipe? recipe) {
    if (recipe == null) return placeholderRecipe();
    return recipe;
  }

  static Recipe placeholderRecipe() {
    return Recipe(
        id: "",
        author: "Generic Startup",
        title: "Loading Recipe...",
        picture: "",
        ingredients: [],
        steps: [],
        hasPage: false);
  }

  static Recipe errorRecipe() {
    return Recipe(
        id: "",
        author: "Generic Startup",
        title: "Unable to Load Recipe!",
        picture: "",
        ingredients: [],
        steps: [],
        hasPage: false);
  }

  static Future<Recipe?> fromId(String id) async {
    print("Getting recipe $id");
    try {
      var response = await HttpHandler.get("api/public/get-recipe-by-id/$id");
      if (response.statusCode == 200) {
        //convert from JSON string to Map<String,dynamic>
        //populate fields
        var map = json.decode(response.body);
        return Recipe.fromDynamic(map);
      }
    } catch (e, s) {
      print(e);
      print(s);
      return errorRecipe();
    }
    return null;
  }
}
