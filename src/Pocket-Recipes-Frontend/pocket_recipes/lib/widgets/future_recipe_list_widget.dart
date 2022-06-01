import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/recipe_list.dart';
import 'package:pocket_recipes/widgets/recipe_list_widget.dart';

class FutureRecipeListWidget extends StatelessWidget {
  Future<RecipeList?> future;

  FutureRecipeListWidget({
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeList?>(
      future: future,
      builder: (BuildContext context,
          AsyncSnapshot<RecipeList?> recipeListSnapshot) {
        //TODO: Make error messages prettier
        if (!recipeListSnapshot.hasData) {
          return Center(
            child: Text(
              "Loading Recipes...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          );
        } else if (recipeListSnapshot.hasError) {
          return Text("Unable to Load Recipes!");
        }

        RecipeList loadedRecipeList =
            RecipeList.fromNullable(recipeListSnapshot.data);
        if (loadedRecipeList.isEmpty) {
          return Center(
            child: Text(
              "No Recipes Found...",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          );
        }
        return RecipeListWidget(recipes: loadedRecipeList);
      },
    );
  }
}
