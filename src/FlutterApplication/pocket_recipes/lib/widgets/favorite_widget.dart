import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/user.dart';
import 'package:pocket_recipes/models/recipe.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';

class FavoriteWidget extends StatefulWidget{
    Recipe recipe;

    FavoriteWidget({
        required this.recipe,
    });

    FavoriteWidgetState createState() => FavoriteWidgetState(recipe:this.recipe);
}


class FavoriteWidgetState extends State<FavoriteWidget>{
    bool isFavorite = false;
    final Recipe recipe;

    FavoriteWidgetState({
        required this.recipe,
    });

    void refreshWidget(){
        setState(() => {
            this.isFavorite = HttpHandler.user.favoriteRecipes.contains(recipe.id)
        });
    }

    void initState(){
        HttpHandler.addHttpEventListener("userLoggedIn", refreshWidget);
        this.isFavorite = HttpHandler.user.favoriteRecipes.contains(recipe.id);
        super.initState();
    }

    void dispose(){
        HttpHandler.removeHttpEventListener("userLoggedIn", refreshWidget);
        super.dispose();
    }

    @override
    Widget build(BuildContext context){
        User user = HttpHandler.user;
        IconData icon = isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded;
        //Do not render if the user has not logged in
        if (user.id == "") return SizedBox.shrink();

        return Align(
          child: Row(
            children: [
          SizedBox(
            width: 290,
          ),
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                  InkWell(
                    onTap: () async {
                      user.setFavoriteRecipe(recipe.id, isFavorite).then((newState){
                            setState(() => {isFavorite = newState});
                      });
                    },
                    child: Icon(
                      icon,
                      color: Colors.red,
                      size: 22,
                    ),
                  )
              ],
            ),
          ),
        ],
        ),
        alignment: Alignment.bottomRight,
    );
    }
}
