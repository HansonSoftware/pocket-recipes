import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/user.dart';
import 'package:pocket_recipes/pages/login_form.dart';
import 'package:pocket_recipes/widgets/profile_widget.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = HttpHandler.user;

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: ListView(physics: BouncingScrollPhysics(), children: [
          ProfileWidget(
            imagePath: user.imagePath,
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(
            height: 220,
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(50),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LoginForm()));
                  ;
                },
                child: Text(
                  'Change User',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ]));
  }

  Widget buildName(User user) => Column(
        children: [UsernameDisplay(), const SizedBox(height: 8)],
      );

  Widget buildCookBooksByUser(User user) => Container(
      padding: EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cookbooks',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'No Cookbooks Yet!',
            style: TextStyle(fontSize: 16),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(50),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => LoginForm()));
                  ;
                },
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          )
        ],
      ));
}

class UsernameDisplay extends StatefulWidget {
  UsernameDisplay({
    Key? key,
  }) : super(key: key);

  UsernameDisplayState createState() => UsernameDisplayState();
}

class UsernameDisplayState extends State<UsernameDisplay> {
  String username = "Guest";
  void refreshWidget() {
    setState(() {
      username = HttpHandler.user.username;
    });
  }

  void initState() {
    HttpHandler.addHttpEventListener("userLoggedIn", refreshWidget);
    HttpHandler.addHttpEventListener("userUpdated", refreshWidget);
    super.initState();
  }

  void dispose() {
    HttpHandler.removeHttpEventListener("userLoggedIn", refreshWidget);
    HttpHandler.addHttpEventListener("userUpdated", refreshWidget);
    super.dispose();
  }

  Widget build(BuildContext context) => Text("Logged in as: " + username,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black));
}
