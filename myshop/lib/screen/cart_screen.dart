import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';
import '../widget/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),

      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                  Spacer(),
                  /// a widget with a rounded corner (?)
                  Chip(
                    label: Text(
                      '\$ ${cart.cartItemPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),

          SizedBox(height: 10,),

          // listview in column widget will not work
          // because of that, wrap it into expanded widget
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItem.length,
              itemBuilder: (ctx, index) => CartItem(
                /// cart.cartItem.values.toList() return value in each maps
                /// kalo cart.cartItem[index] hanya return mapsnya aja
                cart.cartItem.values.toList()[index].id,
                cart.cartItem.keys.toList()[index], // give index of the maps to reference if want to delet from list
                cart.cartItem.values.toList()[index].title, 
                cart.cartItem.values.toList()[index].quantity, 
                cart.cartItem.values.toList()[index].price
              )
            )
          )
        ],
      ),

    );
  }
}

/**
 * Reason to extract order button to separately widget:
 * To only rebuild on the button widget, not entire widget
 */
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? 
              CircularProgressIndicator() 
                : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
      // make button can't be clicked if cart empty
      onPressed: (widget.cart.cartItemPrice <= 0 || _isLoading) ? 
        null 
        : () async {
          setState(() {
            _isLoading = true;
          });

          await Provider.of<OrderProvider>(
            context,
            listen: false // not listen to any changes in order
          )
            .addOrder(
              widget.cart.cartItem.values.toList(), // convert from map to list
              widget.cart.cartItemPrice
            );
          setState(() {
            _isLoading = false;
          });
          // clear cart list after order
          widget.cart.cleanCartList();  
        },
    );
  }
}