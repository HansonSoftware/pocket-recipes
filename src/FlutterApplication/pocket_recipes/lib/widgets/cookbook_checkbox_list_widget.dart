import "package:flutter/material.dart";
import 'package:pocket_recipes/utilities/http_handler.dart';
import "package:pocket_recipes/models/cookbook.dart";
import 'package:pocket_recipes/widgets/cookbook_checkbox_widget.dart';

class CookbookCheckboxList extends StatefulWidget{
    final String recipeId;
    final Set<Cookbook> cookbooks;
    CookbookCheckboxList({
      required this.recipeId,
      required this.cookbooks,
      Key? key,
    }) : super(key: key);


    CookbookCheckboxListState createState() => CookbookCheckboxListState(recipeId:recipeId, cookbooks:cookbooks);
}


class CookbookCheckboxListState extends State<CookbookCheckboxList>{
    List<CookbookCheckbox> cookbookTiles = new List<CookbookCheckbox>.empty(growable: true);
    Set<Cookbook> selectedCookbooks = new Set<Cookbook>();

    final String recipeId;
    Set<Cookbook> cookbooks;


    CookbookCheckboxListState({
        required this.recipeId,
        required this.cookbooks,
    });

    void refreshWidget(){
        print("Refreshing cookbook selection dialog");
        cookbookTiles.clear();
        selectedCookbooks.clear();
        print("Attempting to load ${HttpHandler.user.cookbooks.length} cookbooks...");
        if (cookbooks.length == 0) return;
        for (Cookbook cookbook in HttpHandler.user.cookbooks) {
            cookbookTiles.add(CookbookCheckbox(
                cookbook: cookbook,
                selectedCookbooks: selectedCookbooks,
            ));
        }
        print("Attempting loaded ${cookbookTiles.length} cookbooks!");
    }

    void initState(){
        HttpHandler.addHttpEventListener("cookbookUpdated", refreshWidget);
        refreshWidget();
        super.initState();
    }

    void dispose(){
        HttpHandler.removeHttpEventListener("cookbookUpdated", refreshWidget);
        super.dispose();
    }



    Widget build(BuildContext context)=>AlertDialog(
      title: const Text('Add Recipe to a Cookbook'),
      content: Container(
        height: 400,
        child: Column(
          children: cookbookTiles,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Add',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          onPressed: () {
            Navigator.of(context).pop();
            // This is where we will send the info to create the cookbook
            // _textFieldController.text holds the cookbooks name
            for (Cookbook cookbook in selectedCookbooks) {
              //Search through cookbooks for one that shares the name
              HttpHandler.user.addRecipeToCookbook(recipeId, cookbook);
            }
            // Do something
          },
        ),
        TextButton(
          child: const Text('Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
}
