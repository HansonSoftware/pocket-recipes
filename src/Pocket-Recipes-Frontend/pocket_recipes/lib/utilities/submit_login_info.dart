import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';

class SubmitLogin {
  final String username;
  final String password;

  const SubmitLogin({
    required this.username,
    required this.password,
  });

  static SubmitLogin fromFields(String username, String password) {
    return SubmitLogin(
      username: username,
      password: password,
    );
  }

  void login(BuildContext context, Widget next) {
    //The information being sent to the backend
    Map<String, dynamic> body = {
      'username': this.username,
      'password': this.password
    };

    HttpHandler.post(
      "auth",
      //tell the backend that we will be sending JSON and will expect JSON in return
      headers: {
        'content-type': 'application/json',
        'accept': 'application/json',
      },
      //Encode the body in JSON
      body: jsonEncode(body),
    ).then((http.Response response) async {
      //if logged in successfully, return to previous page
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        bool success = await HttpHandler.setAuth(responseData['userId']);
        if (success) {
          Navigator.of(context).pop();
        } else {
          print("Failed to log in user");
        }
      } else {
        //TODO: Display error message
      }
    });
  }
}
