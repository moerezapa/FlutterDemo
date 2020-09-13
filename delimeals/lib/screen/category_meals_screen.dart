import 'package:flutter/material.dart';

import '../dummy_data.dart';
import '../model/meal.dart';
import '../widget/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  
  // final String categoryId;
  // final String categoryTitle;

  // CategoryMealsScreen(this.categoryId, this.categoryTitle);

  // define ini buat inisiasi nama route
  static const routeName = '/category-meals';

  final List<Meal> availableMeal;

  CategoryMealsScreen(this.availableMeal);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {

  String categoryTitle;
  // a list of meals which are my category
  List<Meal> displayedMeals;
  bool _loadedInitData = false;

  @override
  void initState() {
    /**
     * this function is automically run. gausah dipanggil2 lagi
     * when this page gets loaded, when that state gets created,
     * then we want load all meals that are based on the ID of category
     */

    super.initState();
  }

  @override
  void didChangeDependencies() {
    /**
     * this function will triggered when the references of the state change,
     * which also it will be called when the widget that belongs to the state
     * has been fully initialized
     */
    if (!_loadedInitData) {
      // this code only run for the first time
      final routeArgs = ModalRoute.of(context).settings.arguments
                              as Map<String,String>;
    
      categoryTitle = routeArgs['title']; // handle title from routeArgs
      final categoryId = routeArgs['id'];
      // fitered category
      displayedMeals = widget.availableMeal.where((meal) {
        return meal.categories.contains(categoryId);
      }).toList();
      _loadedInitData = true;
    }
    
    super.didChangeDependencies();
  }
  void _removeMeal(String idMeal) {
    // remove item from diplayed meals
    setState(() {
      displayedMeals.removeWhere((meal) => meal.id == idMeal);
    });
  }

  @override
  Widget build(BuildContext context) {
    // handle arguments from route
    

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      /**
       * ListView buat list yang udah pasti size nya
       * ListView.builder buat yang belum pasti size nya + size yang buesar
       */
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          // return Text(
          //   // categoryMeals[index].title            
          // );
          return MealItem(
              id: displayedMeals[index].id,
              title: displayedMeals[index].title, 
              imageUrl: displayedMeals[index].imageUrl, 
              duration: displayedMeals[index].duration, 
              complexity: displayedMeals[index].complexity, 
              affordability: displayedMeals[index].affordability,
              // removeItem: _removeMeal,
            );
        },
        // how many items you will have
        itemCount: displayedMeals.length,
      ),
    );
  }
}