import 'package:flutter/foundation.dart';
import './cart.dart';

class CartProvider with ChangeNotifier {
  // initiate as empty map
  Map<String, Cart> _cartItems = {};

  // get list of cart item
  Map<String, Cart> get cartItem {
    return {..._cartItems};
  }

  // get how many items in the cart
  int get cartItemCount {
    // how many product in the cart
    return _cartItems.length;
  }

  // get how many price of each product in cart
  double get cartItemPrice {
    var total = 0.0;
    _cartItems.forEach((key,cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // adding to cart item
  void addCartItem(String productId, double price, String title) {
    if(_cartItems.containsKey(productId)) {
      /// if already on cart, change quantity
      _cartItems.update(productId, (existingCartItem) => 
          Cart(
            id: existingCartItem.id, 
            title: existingCartItem.title, 
            quantity: existingCartItem.quantity + 1, 
            price: existingCartItem.price
          ));
    }
      else {
        /// add a new entry to that map
        _cartItems.putIfAbsent(productId, () => 
          Cart(
            id: DateTime.now().toString(), 
            title: title, 
            quantity: 1, 
            price: price
          ));
      }
    notifyListeners();
  }

  // remove from cart
  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  // remove the last addition
  void removeCartItemAddition(String productId) {
    if(!_cartItems.containsKey(productId)) {
      return;
    }
    // reduce the quantity if that product already on list and quantity more than 1
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(productId, (existingCartItem) => 
          Cart(
            id: existingCartItem.id, 
            title: existingCartItem.title, 
            quantity: existingCartItem.quantity - 1, 
            price: existingCartItem.price
          ));
    }
       else {
         _cartItems.remove(productId);
       }
    notifyListeners();
  }
  // clean cart list
  void cleanCartList() {
    _cartItems = {};
    notifyListeners();
  }
}