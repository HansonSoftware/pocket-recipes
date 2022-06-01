import 'package:flutter/material.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:pocket_recipes/widgets/cookbook_checkbox_list_widget.dart';

class RecipePage extends StatelessWidget {
  final String id;
  final String author;
  final String title;
  final String picture;
  final List<dynamic> ingredients;
  final List<dynamic> directions;
  String ingredientsString = "";
  String directionsString = "";
  final TextEditingController _textFieldController = TextEditingController();

  RecipePage(
      {required this.id,
      required this.author,
      required this.title,
      required this.picture,
      required this.ingredients,
      required this.directions});

  @override
  Widget build(BuildContext context) {
    /* Getting the Ingredients */
    for (int i = 0; i < ingredients.length; i++) {
      if (ingredients[i] != null) {
        ingredientsString += "• " + ingredients[i] + "\n";
      }
    }
    /* Getting the Dirctions */
    for (int i = 0; i < directions.length; i++) {
      if (directions[i] != null) {
        int count = i + 1;
        directionsString += "$count. " + directions[i] + "\n";
      }
    }

    return Scaffold(
        appBar: AppBar(
            foregroundColor: Colors.green,
            leading: const BackButton(),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(title)),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          physics: BouncingScrollPhysics(),
          children: [
            Container(
                height: 220,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        Image.network(picture, fit: BoxFit.fill))),
                        //Image(image: NetworkImage(picture), fit: BoxFit.fill))),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Author(s): " + author,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            Text(
              "Ingredients: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 8),
              child: Text(
                ingredientsString,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Directions: ",
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 8),
              child: Text(
                directionsString,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(context), child: Icon(Icons.add)));
  }

  Future<void> _displayDialog(BuildContext context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        HttpHandler.refreshCookbooks();
        print(HttpHandler.user.cookbooks.length);
        return CookbookCheckboxList(recipeId:id, cookbooks:HttpHandler.user.cookbooks);
      },
    );
  }
}
