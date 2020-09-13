import 'package:flutter/material.dart';

import '../model/meal.dart';
import '../widget/meal_item.dart';

class FavoriteScreen extends StatelessWidget {
  
  final List<Meal> favoriteMeals;
  FavoriteScreen(this.favoriteMeals);

  @override
  Widget build(BuildContext context) {
    if(favoriteMeals.isEmpty) {
      return Center(
        child: Text('You have no favorites yet - start adding some!'),
      );
    }
      else {
        return ListView.builder(
          itemBuilder: (ctx, index) {
            // return Text(
            //   // categoryMeals[index].title            
            // );
            return MealItem(
                id: favoriteMeals[index].id,
                title: favoriteMeals[index].title, 
                imageUrl: favoriteMeals[index].imageUrl, 
                duration: favoriteMeals[index].duration, 
                complexity: favoriteMeals[index].complexity, 
                affordability: favoriteMeals[index].affordability,
                // removeItem: _removeMeal,
              );
          },
          // how many items you will have
          itemCount: favoriteMeals.length,
        );
      }
  }
}