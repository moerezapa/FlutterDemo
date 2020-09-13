import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem(
    this.id,
    this.productId,
    this.title,
    this.quantity,
    this.price
  );

  @override
  Widget build(BuildContext context) {
    /// Dismissible widget
    /// give animation and will remove element it wrap from the UI
    return Dismissible(
      // key for avoid issues where it then display the list of which often, this part is rendered incorrectly
      key: ValueKey(id), 
      // swipe direction
      direction: DismissDirection.endToStart,
      // show confirmation dialog
      confirmDismiss: (direction) {
        // use return to return output no/yes from dialog using Future (?)
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Confirmation'),
            content: Text('Do you want to remove item from cart?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                }
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                }
              ),
            ],
          )
        );
      },
      // what happened when already swiped
      onDismissed: (direction) {
        // need direction argument for if you want different
        // function for different direction swipe (?)
        Provider.of<CartProvider>(
          context,
          listen: false
        ).removeCartItem(productId);
      },
      // background behind the element
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4
        ),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 15
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            // information about price
            leading: CircleAvatar(
              // fittedbox bikin widget nyesuaiin size parent widgetnya
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$ $price')
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$ ${price * quantity}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}