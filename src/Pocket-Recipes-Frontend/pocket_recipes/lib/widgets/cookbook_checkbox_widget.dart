import "package:flutter/material.dart";
import 'package:pocket_recipes/models/cookbook.dart';

class CookbookCheckbox extends StatefulWidget{
    final Cookbook cookbook;
    final Set<Cookbook> selectedCookbooks;
    const CookbookCheckbox({
      Key? key,
      required this.cookbook,
      required this.selectedCookbooks,
  }) : super(key: key);

    CookbookCheckboxState createState() => CookbookCheckboxState(cookbook:cookbook, selectedCookbooks:selectedCookbooks);

}

class CookbookCheckboxState extends State<CookbookCheckbox>{
    final Cookbook cookbook;
    final Set<Cookbook> selectedCookbooks;
    bool selected = false;


    CookbookCheckboxState({required this.cookbook, required this.selectedCookbooks});

    Widget build(BuildContext context){
        return CheckboxListTile(
            title: Text(cookbook.name),
            value:selected,
            onChanged: (bool? value){
                setState((){
                    selected = value ?? false;
                    if (selected){
                        selectedCookbooks.add(cookbook);
                    }else{
                        selectedCookbooks.remove(cookbook);
                    }
                });
            }
        );
}
}
