import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:pocket_recipes/widgets/cookbook_list.dart';
import 'package:pocket_recipes/widgets/cookbook_widget.dart';

class CookbooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Your Cookbooks'),
        ),
        body: CookbooksList(),
      );
}
