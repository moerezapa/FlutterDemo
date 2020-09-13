import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {

  final String label; // as weekdayname
  final double spendingAmount;
  final double spendingPctOfTotal;

  // constructor
  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        /**
         * constraint is a feature included by flutter which defines
         * how much space a certain widget may take
         * Constraint define how widget rendered on screen
         */
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                /**
                 * FittedBox force its child into the available space
                 */
                child: Text('\$${spendingAmount.toStringAsFixed(0)}')
              ),
            ),

            SizedBox(height: constraints.maxHeight * 0.05,),
            
            Container(
              // constraints.maxHeight take bar chart that may take
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(children: <Widget>[
                
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1
                    ),
                    /**
                     * fromRGBO allow to mix color
                     * (param1, param2, param3, opacityparam)
                     * param1, param2, param2 value can be between 0 - 255
                     */
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),

                /**
                 * FractionallySizedBox allowed to create a box that is sized as a fractional number
                 * 
                 */
                FractionallySizedBox(
                  heightFactor: spendingPctOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                ),

              ],),
            ),
            SizedBox(height: constraints.maxHeight * 0.05,),

            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label)
              )
            )
            
          ],
        );
      },
    );
  }
}