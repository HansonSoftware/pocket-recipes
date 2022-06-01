import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/recipe.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/pages/recipe_page.dart';
import 'package:pocket_recipes/widgets/favorite_widget.dart';

class RecipeWidget extends StatelessWidget {
  final Recipe recipe;

  RecipeWidget(this.recipe);

  @override
  Widget build(BuildContext context) {
    GestureTapCallback? onTap = () async {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RecipePage(
                id: recipe.id,
                author: recipe.author,
                title: recipe.title,
                picture: recipe.picture,
                ingredients: recipe.ingredients,
                directions: recipe.steps,
              )));
    };
    //Disable button if a page is not associated with the recipe
    if (!recipe.hasPage) {
      onTap = null;
    }
    return InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          width: MediaQuery.of(context).size.width,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.75),
                offset: Offset(
                  0.0,
                  10.0,
                ),
                blurRadius: 10.0,
                spreadRadius: -6.0,
              ),
            ],
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.20),
                BlendMode.multiply,
              ),
              image: NetworkImage(recipe.picture),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    recipe.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
                alignment: Alignment.center,
              ),
              FavoriteWidget(recipe: recipe),
            ],
          ),
        ));
  }
}
