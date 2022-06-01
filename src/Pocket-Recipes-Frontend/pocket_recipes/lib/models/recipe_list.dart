import 'dart:convert';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/models/recipe.dart';
import 'package:pocket_recipes/widgets/recipe_widget.dart';

class RecipeList {
  List<Recipe> recipeList;
  final bool isEmpty;

  RecipeList(
    this.recipeList,
  ) : this.isEmpty = recipeList.isEmpty;

  //Allows us to convert from RecipeList? to RecipeList
  static RecipeList fromNullable(RecipeList? recipeList) {
    if (recipeList == null) return new RecipeList([]);
    return recipeList;
  }

  //Constructs a recipe list from a given endpoint
  static Future<RecipeList?> fromRequest(String endpoint) async {
    try {
      var response = await HttpHandler.get(endpoint);
      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        return RecipeList.fromDynamic(responseBody);
      }
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
    return null;
  }

  //Attempts to convert an object into a recipe list.
  //This function takes every item stored inside the object and attempts to convert it into a recipe.
  static RecipeList fromDynamic(dynamic data) {
    List<Recipe> validRecipes = List<Recipe>.empty(growable: true);
    //Attempt to convert each contained value into a recipe.
    //If a value cannot be converted into a recipe, it is simply excluded from the result.
    for (var recipeData in data) {
      Recipe? recipe = Recipe.fromDynamic(recipeData);
      if (recipe == null) continue;
      validRecipes.add(recipe);
    }
    return RecipeList(validRecipes);
  }


    static Future<RecipeList> fromIdList(Iterable<String> recipeIds) async{
        List<Recipe> validRecipes = List<Recipe>.empty(growable: true);
        for (String id in recipeIds){
            Recipe? recipe = await Recipe.fromId(id);
            print("RECIPE FROM ID: $recipe");
            if (recipe == null) continue;
            validRecipes.add(recipe);
        }
        return RecipeList(validRecipes);
    }


  List<RecipeWidget> toWidgets() {
    List<RecipeWidget> widgets =
        List.of(recipeList.map((recipe) => new RecipeWidget(recipe)));
    return widgets;
  }
}
