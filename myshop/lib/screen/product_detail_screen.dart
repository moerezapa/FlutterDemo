import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  
  static const routeName = "/product-detail-screen";
  // final String title;
  // final double price;
  // ProductDetailScreen(this.title,this.price);

  @override
  Widget build(BuildContext context) {
    
    final productId = ModalRoute.of(context).settings.arguments
                        as String;
    // accessing product provider
    final loadedProduct = Provider.of<ProductProvider>(
      context,
      /// set listen arguments to false if you dont want to rerun this provider (?)
      /// so it only first run when screen first rendered 
      listen: false
    ).findById(productId);

    // get product information from id
    
    return Scaffold(
      /// to implement sliver, we replace singlechildscrollview with
      /// customscrollview and dont need AppBar anymore
      
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),

      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
            
      //       Container(
      //         height: 300,
      //         width: double.infinity,
      //         child: Hero(
      //           tag: loadedProduct.id,
      //           child: Image.network(
      //             loadedProduct.imageUrl,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),

      //       SizedBox(height: 10,),

      //       Text(
      //         '\$ ${loadedProduct.price}',
      //         style: TextStyle(
      //           color: Colors.grey,
      //           fontSize: 20
      //         ),
      //       ),

      //       SizedBox(height: 10),

      //       Container(
      //         width: double.infinity,
      //         padding: EdgeInsets.symmetric(horizontal: 10),
      //         child: Text(
      //           '${loadedProduct.description}',
      //           textAlign: TextAlign.center,
      //           softWrap: true,
      //         ),
      //       ),

      //     ],
      //   ),

      // )

      body: CustomScrollView(
        /// slivers are scrollable areas on the screen
        /// control part of the screen that can scroll
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            // pinned to true to set appbar always be visible
            /// when scrolled
            pinned: true,
            /// flexibleSpace define what should be inside appBar
            /// flexibleSpace must use FlexibleSpaceBar
            /// in this case we still keep title product
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          SliverList(
            /// delegate tell how to render the content of the list
            delegate: SliverChildListDelegate([
              SizedBox(height: 10,),
              Text(
                '\$ ${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${loadedProduct.description}',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(height: 800,)
            ])
          )
        ],
      )
    );
  }
}