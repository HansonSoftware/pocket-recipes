import 'package:flutter/material.dart';
import 'package:pocket_recipes/pages/user_profile_page.dart';

/* ProfilePage:
 * This page displays information about a users profile. */
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Your Account"),
          backgroundColor: Colors.green,
        ),
        body: UserProfilePage(),
      );
}
