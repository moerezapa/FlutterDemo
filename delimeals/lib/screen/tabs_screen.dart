/**
 * This file only manage the tabs and then load different screen
 */
import 'package:flutter/material.dart';

import '../widget/main_drawer.dart';
import './categories_screen.dart';
import './favorites_screen.dart';
import '../model/meal.dart';

class TabScreen extends StatefulWidget {

  final List<Meal> favoriteMeals;
  
  TabScreen(this.favoriteMeals);

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {

  // list of pages would be shown
  /**
   * penambahan <Map<String, Object>> biar bisa ada kustomisasi di masing2 page
   */
  List<Map<String, Object>> _pages;
  // information of which page was selected
  int _selectedPageIndex = 0;

  @override
  void initState() {
    // widget gabisa dipanggil di luar method build()
    _pages = [
      {
        'page': CategoriesScreen(), 
        'title': 'Categories'
      },
      {
        'page': FavoriteScreen(widget.favoriteMeals), 
        'title': 'Your Favorites'
      }
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,  // how many tabs do you want
    //   initialIndex: 0, // initial which screen will be rendered by default
    //   child: Scaffold(
        
    //     appBar: AppBar(
    //       title: Text('Meals'),
    //       bottom: TabBar(
    //         tabs: <Widget>[
    //           Tab(
    //             icon: Icon(Icons.category),
    //             text: 'Category',
    //           ),
    //           Tab(
    //             icon: Icon(Icons.star),
    //             text: 'Favorites',
    //           ),
    //         ]
    //       ),
    //     ),

    //     // render screen from selected tab
    //     body: TabBarView(
    //       children: <Widget>[
    //         // urutan screen harus sama kayak urutan di tab yang di appBar
    //         // page yang diload jangan scaffold karena gabisa ngatur page keseluruhan
    //         CategoriesScreen(),
    //         FavoriteScreen()
    //       ],
    //     ),
    //   )
    // );
    return Scaffold(
        
      appBar: AppBar( title: Text(_pages[_selectedPageIndex]['title']), ),

      body: _pages[_selectedPageIndex]['page'],
    
      // bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white, // set un selected tab color
        selectedItemColor: Theme.of(context).accentColor, // set selected tab color
        currentIndex: _selectedPageIndex, // tells bottom navigation bar which tab is selected
        /**
         * type memberi animasi (?)
         * BottomNavigationBarType.shifting memberi animasi geser2
         * BottomNavigationBarType.fixed gaada animasi
         */
        type: BottomNavigationBarType.shifting,
        // items contain tabs
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('Categories'),
            backgroundColor: Theme.of(context).primaryColor
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorites'),
            backgroundColor: Theme.of(context).primaryColor
          )
        ]
      ),

      drawer: MainDrawer()
    );
  }
}