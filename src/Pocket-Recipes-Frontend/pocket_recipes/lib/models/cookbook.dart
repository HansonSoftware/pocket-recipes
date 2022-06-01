import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/models/recipe_list.dart';
import 'package:pocket_recipes/widgets/cookbook_widget.dart';
import 'package:pocket_recipes/widgets/recipe_widget.dart';

class Cookbook {
  String id;
  String name;
  String authorUserId;
  List<String> recipeIdList;
  String imageURL;

  Cookbook({
    required this.id,
    required this.name,
    required this.authorUserId,
    required this.recipeIdList,
    required this.imageURL,
  });

  static Cookbook? fromDynamic(dynamic cookbookData) {
    try {
      return Cookbook(
        id: cookbookData["id"],
        name: cookbookData["name"],
        authorUserId: cookbookData["authorUserId"],
        recipeIdList: List<String>.from(cookbookData["recipeIdList"] ?? []),
        imageURL: cookbookData["imageURL"] ??
            "https://media.istockphoto.com/vectors/cook-book-with-recipes-vector-id1042636366?k=20&m=1042636366&s=612x612&w=0&h=2NEGlJQhUzSH-1sYjDZuefgvkA8ytEmbWOhwg6o_TA0=",
      );
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  static Cookbook fromNullable(Cookbook? cookbook) {
    return cookbook ??
        Cookbook(
            id: "",
            name: "No Cookbook!",
            authorUserId: "",
            recipeIdList: [],
            imageURL: "");
  }

  static Future<Cookbook?> fromId(String cookbookId) async {
    print("Getting cookbook $cookbookId");
    try {
      var response =
          await HttpHandler.get("api/public/get-cookbook-by-id/$cookbookId");
      if (response.statusCode == 200) {
        var cookbookData = json.decode(response.body);
        return Cookbook.fromDynamic(cookbookData);
      }
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  CookbookWidget toWidget() {
    return CookbookWidget(cookbook: this);
  }
}
