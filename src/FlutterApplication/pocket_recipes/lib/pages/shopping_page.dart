import 'package:flutter/material.dart';
import 'package:pocket_recipes/pages/shopping_list_page.dart';

class ShoppingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
      ),
      body: ShoppingList());
}
