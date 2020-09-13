import 'package:flutter/material.dart';

import '../widget/category_item.dart';
import '../dummy_data.dart';

class CategoriesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // return Scaffold(

    //   appBar: AppBar(
    //     title: const Text('Delimeals'), // adding 'const' will be never rebuilt again
    //   ),

    //   body: GridView(
    //     padding: const EdgeInsets.all(25),
    //     // map every item to shown
    //     children: DUMMY_CATEGORIES
    //         .map((catData) => CategoryItem(
    //           catData.id,
    //           catData.title, 
    //           catData.color
    //         ))
    //       .toList(),
    //     /**
    //      * gridDelegate is a must to be provided
    //      * Sliver                 : in flutter is a scrollable areas on the screen
    //      * GridDelegate           : means for the grid. this takes care about structuring, layouting grid
    //      * WithMaxCrossAxisExtent : preconfigured class which allow to define maximum width each grid item then
    //      *                          it will automically create as many columns as we can fit items
    //      *                          with that provided width next to each other
    //      */
    //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
    //       // if we have 300 pixels, it will show only one item. if 500, will show 2 item side by side
    //       maxCrossAxisExtent: 200,
    //       // define how the items should be sized regarding their height & width relation
    //       childAspectRatio: 3 / 2, // means for 200 width, i want to have 300 height in the end & you can add some spacing
    //       // define distance of our columns and row in that grid
    //       crossAxisSpacing: 20,
    //       mainAxisSpacing: 20
    //     ),
    //   ),
    // );
    return GridView(
        padding: const EdgeInsets.all(25),
        // map every item to shown
        children: DUMMY_CATEGORIES
            .map((catData) => CategoryItem(
              catData.id,
              catData.title, 
              catData.color
            ))
          .toList(),
        /**
         * gridDelegate is a must to be provided
         * Sliver                 : in flutter is a scrollable areas on the screen
         * GridDelegate           : means for the grid. this takes care about structuring, layouting grid
         * WithMaxCrossAxisExtent : preconfigured class which allow to define maximum width each grid item then
         *                          it will automically create as many columns as we can fit items
         *                          with that provided width next to each other
         */
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          // if we have 300 pixels, it will show only one item. if 500, will show 2 item side by side
          maxCrossAxisExtent: 200,
          // define how the items should be sized regarding their height & width relation
          childAspectRatio: 3 / 2, // means for 200 width, i want to have 300 height in the end & you can add some spacing
          // define distance of our columns and row in that grid
          crossAxisSpacing: 20,
          mainAxisSpacing: 20
        ),
    );
  }
}