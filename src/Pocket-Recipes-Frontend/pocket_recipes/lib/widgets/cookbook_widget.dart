import 'package:flutter/material.dart';
import 'package:pocket_recipes/models/cookbook.dart';
import 'package:pocket_recipes/pages/recipe_page.dart';
import 'package:pocket_recipes/pages/cookbook_page_view.dart';
import 'package:pocket_recipes/widgets/recipe_widget.dart';

class CookbookWidget extends StatelessWidget {
  Cookbook cookbook;

  CookbookWidget({
    required this.cookbook,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: ObjectKey(CookbookWidget),
        child: InkWell(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CookbookPageView(cookbook: cookbook)));
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.75),
                      offset: Offset(
                        0.0,
                        10.0,
                      ),
                      blurRadius: 10.0,
                      spreadRadius: -6.0,
                    ),
                  ],
                  image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.20),
                      BlendMode.multiply,
                    ),
                    image: NetworkImage(cookbook.imageURL),
                    fit: BoxFit.cover,
                  )),
              child: Stack(
                children: [
                  Align(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        cookbook.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    alignment: Alignment.center,
                  ),
                ],
              ),
            )));
  }
}
