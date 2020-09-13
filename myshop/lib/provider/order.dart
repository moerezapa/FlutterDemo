import 'package:flutter/foundation.dart';

import './cart.dart';

class Order {
  final String id;
  final double price;
  final List<Cart> productOrder;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.price,
    @required this.productOrder,
    @required this.dateTime
  });
}