import 'package:flutter/material.dart';

import '../model/meal.dart';
import '../screen/meal_detail_screen.dart';

class MealItem extends StatelessWidget {
  
  final String id;
  final String title;
  final String imageUrl;
  final int duration;
  final Complexity complexity;
  final Affordability affordability;
  // final Function removeItem;

  MealItem({
    @required this.id,
    @required this.title,
    @required this.imageUrl,
    @required this.duration,
    @required this.complexity,
    @required this.affordability,
    // @required this.removeItem
  });

  /**
   * dibuat get untuk nangkep value enum Complexity
   * karena Complexity berupa enum yang berisi nilai2
   */
  String get complexityText {
    switch(complexity) {
      case Complexity.Simple:
        return 'Simple';
        break;
      case Complexity.Challenging:
        return 'Challenging';
        break;
      case Complexity.Hard:
        return 'Hard';
        break;
      default:
        return 'Unknown';
    }
  }

  /**
   * dibuat get untuk nangkep value enum Affordability
   * karena Affordability berupa enum yang berisi nilai2
   */
  String get affordabilityText {
    switch(affordability) {
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Luxurious:
        return 'Luxurious';
        break;
      case Affordability.Pricey:
        return 'Expensive';
        break;
      default:
        return 'Unknown';
    }
  }

  void selectMeal(BuildContext ctx) {
    Navigator.of(ctx)
        .pushNamed(
        MealDetailScreen.routeName,
        arguments: id
      )
        .then(
          // then() di eksekusi stelah pushNamed selesai berjalan
          (result) {
            if (result != null) {
              // removeItem(result);
            }
          }
        );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectMeal(context),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        elevation: 4,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            /**
             * Stack widget allow to add widget on top of each other
             * soalnya nanti ada gambar terus ditumpuk tulisan
             */
            Stack(
              children: <Widget>[
                // image harus ber radius biar bisa ngikuti card nya
                /**
                 * ClipRRect is a widget that can use any other widget as a child
                 * and force it into a certain form
                 */
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)
                  ),
                  child: Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity, // takes all the width
                    fit: BoxFit.cover, // BoxFit.cover resize and crop so that fit into container
                  ),
                ),

                /**
                 * Positioned allow us to position the child widget in
                 * absolute coordinate
                 */
                Positioned(
                  bottom: 20, // 20 px from bottom
                  right: 10, // 10 px from the right
                  child: Container(
                    width: 300,
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20
                    ),
                    child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 26,
                          color: Colors.white
                        ),
                        // softwrap buat kalo textnya melebihi container, akan ke bawahnya (?)
                        softWrap: true,
                        /**
                         * Fungsi overflow
                         * buat kalo textnya gacukup pake softwrap, teksnya bakal nge fade out &
                         * nggak ngelebihi container
                         */
                        overflow: TextOverflow.fade,
                      ),
                  ),
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.schedule),
                      SizedBox(width: 6,),
                      Text('$duration min')
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.work),
                      SizedBox(width: 6,),
                      Text(complexityText)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.attach_money),
                      SizedBox(width: 6,),
                      Text(affordabilityText)
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}