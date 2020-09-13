import 'package:flutter/material.dart';

import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  
  static const routeName = '/meal-detail-screen';
  
  final Function toggleFavorite;
  final Function isFavorite;

  MealDetailScreen(this.toggleFavorite, this.isFavorite);

  Widget _buildSectionTitle(BuildContext ctx, String text) {
    return Container(
      margin: EdgeInsets.symmetric( vertical: 10),
      child: Text(
        text,
        style: Theme.of(ctx).textTheme.title,
      ),
    );
  }

  Widget _buildContainer(BuildContext ctx, Widget child) {
    return Container(
            height: 150,
            width: MediaQuery.of(ctx).size.width,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: child,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all( color: Colors.grey ),
              borderRadius: BorderRadius.circular(10)
            )
    );
  }

  @override
  Widget build(BuildContext context) {
    // handle arguments from route
    final mealId = ModalRoute.of(context)
                        .settings.arguments as String;

    // firstWhere give us one meal for which condition is true
    final mealsInformation = DUMMY_MEALS.firstWhere((meal) => meal.id == mealId);

    return Scaffold(
      
      appBar: AppBar(
        title: Text('${mealsInformation.title}'),
      ),

      body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            // container for load image
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                mealsInformation.imageUrl,
                fit: BoxFit.cover, // BoxFit.cover resize and crop so that fit into container
              ),
            ),

            // container for ingredient title
            _buildSectionTitle( context, 'Ingredients' ),

            //container show steps
            // listview kan punya height yang nggak terbatas, makanya dimasukin dalem container
            _buildContainer(
              context, 
              ListView.builder(
                itemCount: mealsInformation.ingredients.length, // how many items you will have
                itemBuilder: (ctx, index) => 
                              Card(
                                color: Theme.of(context).accentColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10
                                  ),
                                  child: Text(
                                    mealsInformation.ingredients[index]
                                  ),
                                ),
                              )
              ),
            ),
            
            // container for step title
            _buildSectionTitle( context, 'Steps' ),
            _buildContainer(
              context, 
              ListView.builder(
                itemCount: mealsInformation.steps.length, // how many items you will have
                itemBuilder: (ctx, index) => 
                              Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: CircleAvatar(
                                      child: Text('# ${(index+1)}'),
                                    ),
                                    title: Text(mealsInformation.steps[index]),
                                  ),
                                  Divider()
                                ],
                              )
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(
                isFavorite(mealId) 
                ? Icons.star 
                : Icons.star_border
        ),
        // onPressed: () {
        //   // popAndPushNamed ngeback terus ngepush ke route tujuan
        //   Navigator.of(context).pop(mealId); // passing mealId data
        // }
        onPressed: () => toggleFavorite(mealId),
      ),
    );
  }
}