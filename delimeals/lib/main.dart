import 'package:delimeals/dummy_data.dart';
import 'package:flutter/material.dart';

import './screen/tabs_screen.dart';
import './screen/categories_screen.dart';
import './screen/category_meals_screen.dart';
import './screen/meal_detail_screen.dart';
import './screen/filters_screen.dart';
import 'model/meal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // maps that handle filters
  // pass this map to FilterScreen to keep filter that configured before
  Map<String, bool> _filters = {
    'gluten' : false,
    'lactose' : false,
    'vegan' : false,
    'vegetarian' : false,
  };

  List<Meal> _availableMeals = DUMMY_MEALS; // pointer to the meal
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    // this method should be called from FilterScreen
    // by pass this method when initiate route below
    setState(() {
      _filters = filterData;

      _availableMeals = DUMMY_MEALS.where((meal) {
        if(_filters['gluten'] && !meal.isGlutenFree) {
          return false;
        }
        if(_filters['lactose'] && !meal.isLactoseFree) {
          return false;
        }
        if(_filters['vegan'] && !meal.isVegan) {
          return false;
        }
        if(_filters['vegetarian'] && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    // if didnt find a meal by id, existingIndex will be -1
    final existingIndex 
          = _favoriteMeals.indexWhere((meal) => meal.id == mealId);

    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    }
    // if didnt find the element
      else {
        setState(() {
          _favoriteMeals.add(DUMMY_MEALS.firstWhere(
            (meal) => meal.id == mealId
          ));
        });
      }
  }

  // check if the meals already on _favoriteMeals or not
  bool _isMealFavorite(String idMealFav) {
    return _favoriteMeals.any((meal) => meal.id == idMealFav);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        //define default font family
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith( // copyWith untuk ngganti default text theme sama settingan yang udah ada
          body1: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          ),
          body2: TextStyle(
            color: Color.fromRGBO(20, 51, 51, 1)
          ),
          title: TextStyle(
            fontSize: 20,
            fontFamily: 'RobotoCondensed',
            fontWeight: FontWeight.bold
          )
        )
      ),
      // home: CategoriesScreen(),
      initialRoute: '/', // alternative buat mastiin ini sebagai default screen
      routes: {
        '/' : (ctx) => TabScreen(_favoriteMeals), // default screen didefinisikan sebagai '/'
        // '/category-meals' : (ctx) => CategoryMealsScreen(),
        CategoryMealsScreen.routeName : (ctx) => CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName : (ctx) => MealDetailScreen(
          _toggleFavorite, // add or remove from favorite
          _isMealFavorite // check is the meals is already on list or not
        ),
        FilterScreen.routeName : (ctx) => FilterScreen(
          _filters,
          _setFilters
        )
      },
      /**
       * onGenerateRoute
       * give you some route setting, so some information about
       * the route like argument or function that you pass to onGenerateRoute
       * this gives you a lot of flexibility coz it gives you access to
       * the settings of the route, so you can find out which arguments this route
       * keuntungan make ini:
       * bisa pindah2 screen kalo memenuhi kondisi tertentu
       */
      // onGenerateRoute: (settings) {

      // },
      /**
       * onUnknownRoute
       * this reached when flutter failed to build a screen with all other
       * measures.
       * Jadi misal ada error, nanti arahin ke page di dalem onUnknownError
       */
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => CategoriesScreen()
        );
      },
    );
  }
}