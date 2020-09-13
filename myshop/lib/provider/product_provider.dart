import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// library to convert dart to JSON
import 'dart:convert';

import '../model/http_exception.dart';
import './product.dart';

class ProductProvider with ChangeNotifier {
  /// is simply a widget which allow to establish behind the scenes
  /// communication tunnels with the helps of the context object which we're getting in
  /// every widget
  
  // in here, we want to define a list of products
  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  List<Product> _items = [];
  final String authToken;
  final String userId;
  // penambahan _items biar nggak kehilangan list product
  // yang udah di dapetin pas di build
  ProductProvider(this.authToken, this.userId, this._items);

  // fetch favorites list
  List<Product> get favoriteItems {
    return _items.where((productFav) => productFav.isFavorite).toList();
  }

  // fetch the list
  List<Product> get items {
    return [..._items];
  }

  Product findById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }

  // async is code that executes whilist other code
  // doesnt wait for it to finished
  // async also return a Future when finished executed
  // add [] to define the parameter is optional (?)
  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    // using const because url willnot changed
    /// add filtering by creatorId on server side  
    /// we must also change rules in firebase side. we add
    /// {
    //   "rules": {
    //     ".read": "auth != null",
    //     ".write": "auth != null",
    //     "product": {
    //       ".indexOn":["creatorId"]
    //     }
    //   }
    // }
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://myshopflutter-42531.firebaseio.com/product.json?auth=$authToken&$filterString';
    // we also fetch favorites product status
    final favoriteurl = 'https://myshopflutter-42531.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
    try {
      final response = await http.get(url);
      //convert response data which is json format and then decode it
      final fetchedProduct = json.decode(response.body) 
                            as Map<String, dynamic>;
      final List<Product> loadedProduct = []; // initiate temporary list
      // check if fetchedOrder is not null
      if (fetchedProduct == null) {
        return;
      }
      // request to get favorite status list
      final favoriteResponse = await http.get(favoriteurl);
      final favoriteData = json.decode(favoriteResponse.body);
      fetchedProduct.forEach((productID,productData) {
        // productID as ID in product db
        // productData as data information each productID
        loadedProduct.add(
          Product(
            id: productID, 
            title: productData['title'], 
            description: productData['description'], 
            price: productData['price'], 
            imageUrl: productData['imageUrl'],
            isFavorite: favoriteData == null ? 
                          false // if there arent anything (null), so that means that product is not being favorite
                          : favoriteData[productID] ?? false // ?? means if not null, we keep get what value disana
          )
        );
      });
      // append loadedProduct to _items
      _items = loadedProduct;
      notifyListeners();
    }
      catch(error) {
        throw (error);
      }
  }
  
  // async is code that executes whilist other code
  // doesnt wait for it to finished
  // async also return a Future when finished executed
  Future<void> addProduct(Product product)  async {
    // using const because url willnot changed
    final url = 'https://myshopflutter-42531.firebaseio.com/product.json?auth=$authToken';
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
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId
        }),
      );

      // this code only executes when above this code is finished to executed
      // this happened because 'await' syntax
      final newProduct = Product(
        id: json.decode(response.body)['name'], 
        title: product.title, 
        description: product.description, 
        price: product.price,
        imageUrl: product.imageUrl
      );
      _items.add(newProduct);
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

    /** ALTERNATIVE WAY WITH RETURN A FUTURE */
    /// await is syntax that tells dart to wait this code to finish
    /// before move on the next line
    // return http.post(
    //   url,
    //   // headers are metadata which you can attach to your http request
    //   // headers: ,

    //   // body allows us to define the request body which is the data
    //   // that gets attached to the request
    //   // in the body we should use JSON data because it's only 
    //   // handle JSON format data
    //   body: json.encode({
    //      // we should pass a map if we want to be encoded to json
    //     'title': product.title,
    //     'description': product.description,
    //     'price': product.price,
    //     'imageUrl': product.imageUrl,
    //     'isFavorite': product.isFavorite
    //   }),
    // )
    //   .then((response) {
    //     /// then() only execute when function before then()
    //     /// succeed execute
    //     final newProduct = Product(
    //       id: json.decode(response.body)['name'], 
    //       title: product.title, 
    //       description: product.description, 
    //       price: product.price,
    //       imageUrl: product.imageUrl
    //     );
    //     _items.add(newProduct);
    //     /// alternative for add product to list
    //     // add newProduct to the beginning of the list
    //     // _items.insert(0, newProduct);
        
    //     // let all listener know the update (?)
    //     // this method is kind of setState() but in provider package version
    //     notifyListeners();
    //   })
    //     .catchError((error) {
    //       // catchError executed if main function fail executed
    //       print(error);
    //       /// throw takes an error object so we can get
    //       /// an error object and it will create a new error
    //       throw error;
    //     });
  }
  // async is code that executes whilist other code
  // doesnt wait for it to finished
  // async also return a Future when finished executed
  Future<void> updateProduct(String updatedproductid, Product updatedproduct) async {
    final prodIndex = _items.indexWhere(
                          (prod) => prod.id == updatedproductid
                      );
    if (prodIndex >= 0) {
      final url = 'https://myshopflutter-42531.firebaseio.com/product/$updatedproductid.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          // we should pass a map if we want to be encoded to json
          'title': updatedproduct.title,
          'description': updatedproduct.description,
          'price': updatedproduct.price,
          'imageUrl': updatedproduct.imageUrl,
        })
      );
      _items[prodIndex] = updatedproduct;
      notifyListeners();
    }
      else {
        print('...');
      }
  }
  Future<void> deleteProduct(String deletedproductid) async {
    final url = 'https://myshopflutter-42531.firebaseio.com/product/$deletedproductid.json?auth=$authToken';
    // give us index which want to removed
    final existingProductIndex = _items.indexWhere((prod) => prod.id == deletedproductid);
    var existingProduct = _items[existingProductIndex];
    // remove from the list, not memory
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    // if success to delete
    print(response.statusCode); // if fail it gonna print 405
    if (response.statusCode >= 400) {
      // if failed to delete product, reinsert it back
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      /// this method is called optimistic updating
      /// if it failed, it reinsert back (?)
      // build your own exception by throwing Exception
      throw HttpException('Could not delete product').toString();
    }
    existingProduct = null;

    // await http.delete(url)
    //       .then((response) {
    //         // if success to delete
    //         print(response.statusCode); // if fail it gonna print 405
    //         if (response.statusCode >= 400) {
    //           // build your own exception by throwing Exception
    //           throw HTTPException('Could not delete product').toString();
    //         }
    //         existingProduct = null;
    //       })
    //       .catchError((_) {
    //         // if failed to delete product, reinsert it back
    //         _items.insert(existingProductIndex, existingProduct);
    //         notifyListeners();
    //         /// this method is called optimistic updating
    //         /// if it failed, it reinsert back (?)
    //       });
  }
}