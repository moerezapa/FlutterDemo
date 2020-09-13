import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../widget/order_item.dart';
import '../provider/order_provider.dart';

class OrderScreen extends StatefulWidget {
  
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  // var _isLoading = false;
  /**
  //  * Alternate way of using Provider when first open page
  //  * 1.
  //  * put Future.delayed(Duration.zero)
  //           .then((_) {
  //             < YOUR PROVIDER >
  //           });
  //  * 2. put on didChangeDependencies because that method will run after 
  //  * the widget fully executed
  //  * also you need variable helper that check you running first time
  //  * or not
  //  */
  // @override
  // void initState() {
  //   Future.delayed(Duration.zero)
  //           .then((_) async {
  //             setState(() {
  //               _isLoading = true;
  //             });
  //             // await will make dart not executed until this finished running
  //             await Provider.of<OrderProvider>(
  //               context,
  //               listen: false
  //             ).fetchAndSetOrder();
  //             setState(() {
  //               _isLoading = false;
  //             });
  //           });
  //   super.initState();
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final orders = Provider.of<OrderProvider>(context);

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Your Order'),
  //     ),

  //     body: _isLoading ? 
  //           Center(child: CircularProgressIndicator(),) 
  //           : ListView.builder(
  //               itemCount: orders.orderList.length,
  //               itemBuilder: (ctx, index) => OrderItem(
  //                 orders.orderList[index]
  //               ),
  //             ),

  //     drawer: AppDrawer(),
  //   );
  // }

  /// COBA IMPLEMENTASI FUTURE BUILDER, DIATAS GAPAKE FUTURE BUILDER
  /// FutureBuilder bisa dipake di statelesswidget
  @override
  Widget build(BuildContext context) {
    /// by default, FutureBuilder bakal nge loop berulang2
    /// oleh karena itu, gausah final orders = Provider.of<OrderProvider>(context);
    // final orders = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Order'),
      ),

      /// FutureBuilder takes a future and automically has then() and catchError()
      /// built in (?)
      /// 
      body: FutureBuilder(
        future: Provider.of<OrderProvider>(
                context,
                listen: false
        ).fetchAndSetOrder(),
        builder: (ctx, dataSnapshot) {
          // show the current connection state
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
            else {
              // if you has any error
              if (dataSnapshot.error != null) {
                // do error handling
                return Center(
                  child: Text('An error occured!'),
                );
              }
              // if you hasn't any error
               else {
                 return Consumer<OrderProvider>(
                   builder: (ctx, orderData, child) => 
                            ListView.builder(
                                itemCount: orderData.orderList.length,
                                itemBuilder: (ctx, index) => OrderItem(
                                  orderData.orderList[index]
                                ),
                            )
                 ); 
               }
            }
        }
      ),

      drawer: AppDrawer(),
    );
  }
}