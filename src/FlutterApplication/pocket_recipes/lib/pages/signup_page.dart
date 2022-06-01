import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:pocket_recipes/models/user.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/utilities/submit_login_info.dart';
import 'package:pocket_recipes/widgets/profile_widget.dart';
import 'package:pocket_recipes/widgets/text_field_widget.dart';
import 'package:pocket_recipes/pages/user_profile_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    String username = "";
    String name = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.green,
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset(
            'lib/img/Logo2.png',
            width: 224,
            height: 224,
          ),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Username',
            text: username,
            onChanged: (value) => username = value,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Password',
            text: '',
            onChanged: (value) => password = value,
          ),
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.only(top: 40),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.orange.shade700),
                  minimumSize: MaterialStateProperty.all(Size(180, 50)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ))),
              onPressed: () {
                HttpHandler.post(
                  "subs",
                  //tell the backend that we will be sending JSON and will expect JSON in return
                  headers: {
                    'content-type': 'application/json',
                    'accept': 'application/json',
                  },
                  body: json.encode({
                    "username": username,
                    "password": password,
                  }),
                ).then((response) async {
                  if (response.statusCode == 200) {
                    var responseData = json.decode(response.body);
                    if (responseData["response"] ==
                        "Successful Subscription for client $username") {
                      SubmitLogin loginForm =
                          SubmitLogin.fromFields(username, password);
                      Navigator.of(context).pop();
                      loginForm.login(context, UserProfilePage());
                    }
                  }
                  //TODO: Indicate sign-up failed
                });
              },
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
