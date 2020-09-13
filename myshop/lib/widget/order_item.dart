import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // buat formatting datetime (?)
import 'dart:math';

import '../provider/order.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ?
              min(widget.order.productOrder.length * 20.0 + 110, 200)
              : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$ ${widget.order.price}'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm')
                  .format(widget.order.dateTime)
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less 
                    : Icons.expand_more
                ), 
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }
              ),
            ),

            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _expanded ? 
                      min(widget.order.productOrder.length * 20.0 + 10, 100)
                      : 0,
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 15
              ),
              child: ListView(
                  children: widget.order.productOrder
                    .map(
                      (prod) =>
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              '${prod.quantity} x \$ ${prod.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey
                              ),
                            )
                          ],
                        )
                    ).toList()
              )
            ),
          ],
        ),
      ),
    );
  }
}