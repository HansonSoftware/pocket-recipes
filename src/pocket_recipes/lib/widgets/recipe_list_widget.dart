import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/recipe_list.dart';

class RecipeListWidget extends StatelessWidget {
  final RecipeList recipes;
  final bool isPaginated = false;

  RecipeListWidget({required this.recipes});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: recipes.toWidgets(),
      ),
    );
  }
}
