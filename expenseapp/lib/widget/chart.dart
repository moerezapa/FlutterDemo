import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../model/transaction.dart';

class Chart extends StatelessWidget {
  
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions); // constructor

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if  (recentTransactions[i].date.day == weekDay.day 
              && recentTransactions[i].date.month == weekDay.month
                && recentTransactions[i].date.year == weekDay.year) {
                  totalSum += recentTransactions[i].amount;
              }
      }

      // print(DateFormat.E(weekDay));
      // print(DateFormat.E().format(weekDay).substring(0,1));
      // print(totalSum);
      /**
       * DateFormat.E() is a shortcut to refers code for day
       * ex: M for monday, T for Tuesday
       */
      return {
        'day' : DateFormat.E().format(weekDay).substring(0,1), 
        'amount' : totalSum};
    }).reversed.toList();
  }

  double get totalSpending {
    /**
     * fold() is to reduce a collection to a single value by
     * iteratively combining each element of the collection with an existing value
     */
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
          elevation: 6,
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
                return Flexible(
                  /**
                   * fit arguments
                   * tight --> the child cant also grow up bcs by default every child has same space
                    * loose --> 
                    */
                  fit: FlexFit.tight,
                  child: ChartBar(
                       data['day'], 
                       data['amount'], 
                      // (data['amount'] as double) / totalSpending, // become error if hasn't transaction
                       // supaya nggak error, jadiin gini
                       totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending
                  ),
                );
              }).toList(),
            ),
          ),
        );
  }
}