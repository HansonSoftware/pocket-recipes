import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:pocket_recipes/models/recipe_list.dart';
import 'package:pocket_recipes/utilities/http_handler.dart';
import 'package:pocket_recipes/widgets/future_recipe_list_widget.dart';
import 'package:pocket_recipes/widgets/cookbook_widget.dart';

class CookbookPageView extends StatefulWidget {
  final Cookbook cookbook;
  const CookbookPageView({
    Key? key,
    required this.cookbook,
  }) : super(key: key);

  CookbookPageViewState createState() =>
      CookbookPageViewState(cookbook: this.cookbook);
}

class CookbookPageViewState extends State<CookbookPageView> {
  Cookbook cookbook;

  CookbookPageViewState({
    required this.cookbook,
  });

  void refreshWidget() async {
    Cookbook? updatedCookbook = await Cookbook.fromId(cookbook.id);
    setState(() => {
          this.cookbook = updatedCookbook ?? this.cookbook,
        });
    print(this.cookbook.recipeIdList);
  }

  void initState() {
    HttpHandler.addHttpEventListener("cookbookUpdated", refreshWidget);
    refreshWidget();
    super.initState();
  }

  void dispose() {
    HttpHandler.removeHttpEventListener("cookbookUpdated", refreshWidget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.green,
          leading: const BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(cookbook.name)),
      body: FutureRecipeListWidget(
        future: RecipeList.fromIdList(cookbook.recipeIdList),
      ));
}
