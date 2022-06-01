import 'package:flutter/material.dart';
import 'package:pocket_recipes/pages/cookbooks_page.dart';
import 'package:pocket_recipes/pages/explore_page.dart';
import 'package:pocket_recipes/pages/favorites_page.dart';
import 'package:pocket_recipes/pages/profile_page.dart';
import 'package:pocket_recipes/pages/shopping_page.dart';

Future main() async {
  /* Ensure that upon running, all widgets are initialized */
  WidgetsFlutterBinding.ensureInitialized();

  /* Runs PocketRecipes asynchronously in main */
  runApp(const PocketRecipes());
}

class PocketRecipes extends StatelessWidget {
  const PocketRecipes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pocket Recipes',
      /* The Theme uses various shades of Green, White and Orange */
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.green.shade800,
            selectionColor: Colors.green.shade50),
        primarySwatch: Colors.green,
      ),
      home: const MainPage(title: 'Pocket Recipes'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentIndex = 0;
  /* These 'screens' will be the main pages housed in the navigation bar */
  final screens = [
    ExplorePage(),
    CookbooksPage(),
    FavoritesPage(),
    ShoppingPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      /* Using an IndexedStack allows for pages attributes to be saved upon navigation */
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.green,
          selectedItemColor: Colors.white,
          iconSize: 32,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          /* This list of BottomNavigationBarItem's holds the contents of the navigation bar,
           * which can be toggled through by clicking. */
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu),
                label: 'Explore',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: 'Cookbooks',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Groceries',
                backgroundColor: Colors.green),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.green)
          ]));
}
