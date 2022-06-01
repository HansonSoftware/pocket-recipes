import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:pocket_recipes/models/user.dart';

final String url = "http://10.0.0.4:8080/";
final client = http.Client();
final httpClient = HttpClient();

class HttpHandler {
  static User user = User.fromNullable(null);
  static Set<Function> refreshUserHandlers = Set<Function>();
  static Set<Function> refreshCookbookHandlers = Set<Function>();

  static bool refreshUsers() {
    for (Function func in refreshUserHandlers) {
      func();
    }
    return true;
  }

  static bool refreshCookbooks() {
    for (Function func in refreshCookbookHandlers) {
      func();
    }
    return true;
  }

  static void addHttpEventListener(String event, Function listener) {
    switch (event) {
      case "userLoggedIn":
      case "userUpdated":
        //print("Adding function ${listener.hashCode} to run when user changes");
        refreshUserHandlers.add(listener);
        //print("There are now ${refreshUserHandlers.length} functions that will run when the user changes");
        break;
      case "cookbookUpdated":
        //print("Adding function ${listener.hashCode} to run when a cookbook changes");
        refreshCookbookHandlers.add(listener);
        //print("There are now ${refreshUserHandlers.length} functions that will run when a cookbook changes");
        break;
    }
  }

  static void removeHttpEventListener(String event, Function listener) {
    switch (event) {
      case "userLoggedIn":
      case "userUpdated":
        //print("Removing function ${listener.hashCode} from set of functions to run when user changes");
        refreshUserHandlers.remove(listener);
        //print("There are now ${refreshUserHandlers.length} functions that will run when the user changes");
        break;
      case "cookbookUpdated":
        //print("Adding function ${listener.hashCode} to run when a cookbook changes");
        refreshCookbookHandlers.remove(listener);
        //print("There are now ${refreshUserHandlers.length} functions that will run when a cookbook changes");
        break;
    }
  }

  static Future<bool> setAuth(String userId) async {
    //print("Setting authenticated user to user $userId");
    var response = await get("api/get-authenticated-user/$userId");
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      User? userData = User.fromDynamic(responseData);
      user = User.fromNullable(userData);
      refreshUsers();
      //print("Logged in user has id ${user.id}");
      return userData != null;
    } else {
      //print("Failed to log in user!");
      return false;
    }
  }

  static Future<http.Response> get(String endpoint,
      {Map<String, String>? headers}) {
    String endpointUrl = "$url$endpoint";
    print("GET $endpointUrl");
    return client.get(
      Uri.parse(endpointUrl),
      headers: headers,
    );
  }

  static Future<http.Response> post(String endpoint,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    String endpointUrl = "$url$endpoint";
    print("POST $endpointUrl");
    return client.post(
      Uri.parse(endpointUrl),
      headers: headers,
      body: body,
      encoding: encoding,
    );
  }
}
