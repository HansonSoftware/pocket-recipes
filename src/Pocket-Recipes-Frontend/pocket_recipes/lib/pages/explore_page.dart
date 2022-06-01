import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pocket_recipes/widgets/future_recipe_list_widget.dart';
import 'package:pocket_recipes/models/recipe_list.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';

class ExplorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Explore')]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewSeachDelegate(),
              );
            },
          )
        ],
      ),
      body: FutureRecipeListWidget(
          future: RecipeList.fromRequest("api/public/get-all-recipes/0/20")),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context), child: Icon(Icons.add)));
}

Future<void> _displayDialog(BuildContext context) async {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController stepsController = TextEditingController();

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return Center(
        child: AlertDialog(
          title: const Text('Create a Recipe!', textAlign: TextAlign.center),
          content: Container(
            height: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //position
              mainAxisSize: MainAxisSize.min,
              // wrap content in flutter
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Name:'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(hintText: "Author:"),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(hintText: "Image Link:"),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                      hintText: "Ingredients: \'Eggs; \'"),
                ),
                TextField(
                  controller: stepsController,
                  decoration: const InputDecoration(
                      hintText: "Steps: \'Pour into bowl; \'"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Create',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              onPressed: () {
                print(nameController.text);
                print(authorController.text);
                print(imageController.text);
                print(ingredientsController.text);
                print(stepsController.text);
                Navigator.of(context).pop();
                List<String> ingredients =
                    parseBySemiColon(ingredientsController.text);
                List<String> steps = parseBySemiColon(stepsController.text);
                HttpHandler.post(
                  "api/create-recipe",
                  headers: {
                    'content-type': 'application/json',
                    'accept': 'application/json',
                  },
                  body: json.encode({
                    "userId": HttpHandler.user.id,
                    "authors": [authorController.text],
                    "name": nameController.text,
                    "photoURL": imageController.text,
                    "directions": steps,
                    "ingredients": ingredients,
                    "ingredientNames": ingredients,
                  }),
                );
                // This is where we will send the info to create the cookbook
                // _textFieldController.text holds the cookbooks name
                nameController.clear();
                authorController.clear();
                imageController.clear();
                ingredientsController.clear();
                stepsController.clear();
                // Do something
              },
            ),
            TextButton(
                child: const Text('Cancel',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      );
    },
  );
}

List<String> parseBySemiColon(String incoming) {
  final values = incoming.split(';');
  return values;
}

class NewSeachDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => close(context, null), // Close SearchBar
      );

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
        )
      ];

  @override
  Widget buildResults(BuildContext context) => FutureRecipeListWidget(
      future:
          RecipeList.fromRequest("api/public/get-recipes-by-name/$query/0/20"));

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = ['Custard', 'Hamburgers', 'Chicken'];

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;

            showResults(context);
          },
        );
      },
    );
  }
}
