import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// library to convert dart to JSON
import 'dart:convert';

import './cart.dart';
import './order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _order = [];
  final String authToken;
  final String userId;
  
  /// penambahan _order di argument biar nggak ilang pas di rebuild (?) 
  OrderProvider(this.authToken, this.userId, this._order);

  List<Order> get orderList {
    return [..._order];
  }

  // add order
  // async is code that executes whilist other code
  // doesnt wait for it to finished
  // async also return a Future when finished executed
  Future<void> addOrder(List<Cart> productOrderList, double totalPrice)  async {
    // using const because url willnot changed
    final url = 'https://myshopflutter-42531.firebaseio.com/order/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    /// we dont have to return to future because it already wrapped
    /// in Future method
    
    // for error handling in async, use try catch
    // wrap code in try which is might eventually fail
    try {
      final response = await http.post(
        url,
        // headers are metadata which you can attach to your http request
        // headers: ,

        // body allows us to define the request body which is the data
        // that gets attached to the request
        // in the body we should use JSON data because it's only 
        // handle JSON format data
        body: json.encode({
          // we should pass a map if we want to be encoded to json
          'price': totalPrice,
          'dateTime': timestamp.toIso8601String(),
          'productOrder': productOrderList.map((cp) => {
            'id': cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          }).toList()
        }),
      );

      // this code only executes when above this code is finished to executed
      // this happened because 'await' syntax
      _order.insert(
        0, 
        Order(
          id: json.decode(response.body)['name'], 
          price: totalPrice, 
          productOrder: productOrderList, 
          dateTime: timestamp
        )
      );

      /// alternative for add product to list
      // add newProduct to the beginning of the list
      // _items.insert(0, newProduct);
          
      // let all listener know the update (?)
      // this method is kind of setState() but in provider package version
      notifyListeners();
    }
     catch (error) {
        //  catchError executed if main function fail executed
        print(error);
        /// throw takes an error object so we can get
        /// an error object and it will create a new error
        throw error;
     }
  }

  // fetch order
    // async is code that executes whilist other code
    // doesnt wait for it to finished
    // async also return a Future when finished executed
  Future<void> fetchAndSetOrder() async {
    // using const because url willnot changed
    final url = 'https://myshopflutter-42531.firebaseio.com/order/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      //convert response data which is json format and then decode it
      final fetchedOrder = json.decode(response.body)
                            as Map<String, dynamic>;
      // helper list to handle full order list
      final List<Order> loadedOrder = [];
      // check if fetchedOrder is not null
      if (fetchedOrder == null) {
        return;
      }
      fetchedOrder.forEach((orderId, orderData) {
        loadedOrder.add(Order(
          id: orderId, 
          price: orderData['price'],  
          dateTime: DateTime.parse(orderData['dateTime']),
          // because productOrder is list we define it as List
          productOrder: (orderData['productOrder'] as List<dynamic>)
                          .map((orderItem) => 
                            Cart(
                              id: orderItem['id'], 
                              title: orderItem['title'], 
                              quantity: orderItem['quantity'], 
                              price: orderItem['price']
                            )
                          ).toList()
        ));
      });
      // reverse the list
      _order = loadedOrder.reversed.toList();
      notifyListeners();
    }
      catch(error) {
        throw (error);
      }
  }
}