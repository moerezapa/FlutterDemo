import 'package:flutter/material.dart';
// import this if want to use provider
import 'package:provider/provider.dart';

import '../widget/product_item.dart';
import '../provider/product_provider.dart';

class ProductsGrid extends StatelessWidget {

  final bool _showFavorites;
  ProductsGrid(this._showFavorites);

  @override
  Widget build(BuildContext context) {

    // set up direct communication to provider
    /// we can use Provider.of<object name>(context) to specific which data actually want to listen
    /// set listen arguments to true if you want to always updated state
    final productsData = Provider.of<ProductProvider>(context, listen: true);
    final products = _showFavorites ? 
                        productsData.favoriteItems : 
                          productsData.items;
    
    return GridView.builder(
      padding: const EdgeInsets.all(10), // const biar nggak ke rebuild
      itemCount: products.length, // how many item to build

      /// itemBuilder holds a function to receive data
      /// and define how item to build
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // return a value which we want to provide
        // builder: (c) => products[index]
        value: products[index],
        // providing a single product which means we dont have to receive our product item as argument in ProductItem
        // child: ProductItem(
        //   products[index].id,
        //   products[index].title,
        //   products[index].imageUrl
        // ),
        child: ProductItem(),
      ),
      
      /// gridDelegate allow us to how the grid generally should be structured
      /// like how many columns do you want
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10, // spacing between columns
        mainAxisSpacing: 10, // spacing between rows
        
      ), 
      
    );
  }
}