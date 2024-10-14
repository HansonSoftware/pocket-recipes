import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/recipe_list.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/widgets/future_recipe_list_widget.dart';

class FavoritesPage extends StatefulWidget {
    FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage>{
  Set<String> favoriteRecipes = HttpHandler.user.favoriteRecipes;

  void refreshWidget(){
      setState(() => {
          this.favoriteRecipes = HttpHandler.user.favoriteRecipes,
      });
      print("Favorite recipes: ${this.favoriteRecipes}");
  }

  void initState(){
      HttpHandler.addHttpEventListener("userLoggedIn", refreshWidget);
      HttpHandler.addHttpEventListener("userUpdated", refreshWidget);
      this.favoriteRecipes = HttpHandler.user.favoriteRecipes;
      super.initState();
  }

  void dispose(){
      HttpHandler.removeHttpEventListener("userLoggedIn", refreshWidget);
      HttpHandler.addHttpEventListener("userUpdated", refreshWidget);
      super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites'),
      ),
      body: FutureRecipeListWidget(
          future: RecipeList.fromIdList(favoriteRecipes),
      )
   );
}
