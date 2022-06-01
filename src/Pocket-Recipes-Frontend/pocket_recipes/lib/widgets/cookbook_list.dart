import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:pocket_recipes/models/user.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/widgets/cookbook_widget.dart';

class CookbooksList extends StatefulWidget {
  @override
  _CookbookListState createState() => new _CookbookListState();
}

class _CookbookListState extends State<CookbooksList> {
  List<Cookbook> cookbooks = List<Cookbook>.empty();
  final TextEditingController _textFieldController = TextEditingController();

  void refreshWidget() {
    User user = HttpHandler.user;
    if (user.id == "") return;
    HttpHandler.get("api/get-cookbooks-by-user/${user.id}").then((response) {
      List<Cookbook> validCookbooks = new List<Cookbook>.empty(growable: true);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);
        for (dynamic value in data) {
          Cookbook? loadedCookbook = Cookbook.fromDynamic(value);
          if (loadedCookbook == null) continue;
          validCookbooks.add(loadedCookbook);
        }
        setState(
          () => this.cookbooks = validCookbooks,
        );
      }
    });
  }

  void initState() {
    HttpHandler.addHttpEventListener("cookbookUpdated", refreshWidget);
    HttpHandler.addHttpEventListener("userLoggedIn", refreshWidget);
    refreshWidget();
    super.initState();
  }

  void dispose() {
    HttpHandler.removeHttpEventListener("cookbookUpdated", refreshWidget);
    HttpHandler.removeHttpEventListener("userLoggedIn", refreshWidget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CookbookWidget> cookbookWidgets =
        new List<CookbookWidget>.empty(growable: true);
    for (Cookbook cookbook in cookbooks) {
      cookbookWidgets.add(cookbook.toWidget());
    }
    return new Scaffold(
        // this is where the recipe list goes
        body: ListView(
          children: cookbookWidgets,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _displayDialog(), child: Icon(Icons.add)));
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create a Cookbook'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: '\'Grandmas Recipes\''),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Create',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              onPressed: () {
                print(_textFieldController.text);
                Navigator.of(context).pop();
                HttpHandler.user.createCookbook(_textFieldController.text);
                // This is where we will send the info to create the cookbook
                // _textFieldController.text holds the cookbooks name
                _textFieldController.clear();
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
      },
    );
  }
}
