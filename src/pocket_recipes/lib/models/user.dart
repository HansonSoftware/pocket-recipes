import 'dart:convert';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:http/http.dart' as http;

class User {
  final String imagePath;
  final String id;
  final String name;
  final String username;
  Set<String> favoriteRecipes = Set<String>();
  Set<Cookbook> cookbooks = Set<Cookbook>();

/*
  User({
    required this.imagePath,
    required this.name,
    required this.username,
});*/

  User({
    required this.id,
    required this.name,
    required this.username,
  }) : this.imagePath = "https://i.stack.imgur.com/l60Hf.png";

  static User fromNullable(User? user) {
    return user ?? User(id: "", name: "Guest", username: "Guest");
  }

  User copy({String? id, String? name, String? username}) => User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username);

  Map<String, dynamic> toJson() =>
      {'imagePath': imagePath, 'name': name, 'username': username};

  static Future<User?> fromAuthenticatedUser() async {
    try {
      var response = await HttpHandler.get(
        "api/get-authenticated-user/${HttpHandler.user.id}",
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return User(
          id: responseData['id'],
          name: responseData['username'],
          username: responseData['username'],
        );
      }
    } catch (e, s) {
      print(e);
      print(s);
      throw e;
    }
    return null;
  }

  static User? fromDynamic(dynamic data) {
    try {
      //user data may be the data itself, or in a field called "userModel"
      dynamic userData = data["userModel"] ?? data;
      User newUser = User(
        id: userData["id"],
        name: userData["username"],
        username: userData["username"],
      );
      newUser.favoriteRecipes =
          Set<String>.from(userData["favoriteRecipeIds"] ?? []);
      newUser.cookbooks = Set<Cookbook>.from(
          (data["userOwnedCookbooks"] ?? []).map(Cookbook.fromDynamic));
      return newUser;
    } catch (e, s) {
      print(e);
      print(s);
      return null;
    }
  }

  Future<bool> setFavoriteRecipe(String recipeId, bool isFavorite) async {
    if (isFavorite) {
      var response = await HttpHandler.post(
          "api/unfavorite-recipe/${this.id}/${recipeId}");
      if (response.statusCode == 200) {
        this.favoriteRecipes.remove(recipeId);
        HttpHandler.refreshUsers();
        print("User ${this.id} removed recipe ${recipeId} as a favorite");
        return false;
      }
    } else {
      var response =
          await HttpHandler.post("api/favorite-recipe/${this.id}/${recipeId}");
      if (response.statusCode == 200) {
        this.favoriteRecipes.add(recipeId);
        HttpHandler.refreshUsers();
        print("User ${this.id} favorited recipe ${recipeId}");
        return true;
      }
    }

    //if failed, do not update isFavorite
    return isFavorite;
  }

  Future<bool> addRecipeToCookbook(String recipeId, Cookbook cookbook) async {
    var response = await HttpHandler.post(
      "api/add-recipe-to-cookbook",
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode({
        "userId": this.id,
        "cookbookId": cookbook.id,
        "recipeId": recipeId,
      }),
    );
    if (response.statusCode == 200) {
      //HttpHandler.refreshCookbooks();
      cookbook.recipeIdList.add(recipeId);
      return true;
    }
    return false;
  }

  Future<bool> createCookbook(String name) async {
    var response = await HttpHandler.post(
      "api/create-new-cookbook",
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      body: json.encode({
        "userId": this.id,
        "name": name,
        "imageURL":
            "https://media.istockphoto.com/vectors/cook-book-with-recipes-vector-id1042636366?k=20&m=1042636366&s=612x612&w=0&h=2NEGlJQhUzSH-1sYjDZuefgvkA8ytEmbWOhwg6o_TA0="
      }),
    );
    if (response.statusCode == 200) {
      var userCookbookResponse =
          await HttpHandler.get("api/get-cookbooks-by-user/${id}");
      if (userCookbookResponse.statusCode == 200) {
        dynamic data = json.decode(userCookbookResponse.body);
        cookbooks = Set<Cookbook>.from((data ?? []).map(Cookbook.fromDynamic));
        await HttpHandler.refreshCookbooks();
        return true;
      }
    }
    return false;
  }
}
