import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// library to convert dart to JSON
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  // use named argument with '{}'
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false, // set false by default
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  // switch favorite status of a product
  Future<void> toggleFavorite(String token, String userId) async {
    // save current favorit status
    final currentStatus = isFavorite;
    isFavorite = !isFavorite;
    // let all listener know the update (?)
    // this method is kind of setState() but in provider package version
    notifyListeners();
    final url = 'https://myshopflutter-42531.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        /// use put request because we just want to send true/false as a value
        url,
        body: json.encode(
          isFavorite
        )
      );
      if (response.statusCode >= 400) {
        _setFavValue(currentStatus);
      }
    }
      catch(error) {
        _setFavValue(currentStatus);
      }
  }
}