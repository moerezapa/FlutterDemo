import 'package:flutter/material.dart';
import 'package:myshop/provider/auth_provider.dart';

import 'package:provider/provider.dart';

import '../screen/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/cart_provider.dart';

class ProductItem extends StatelessWidget {
  
  // final String id;
  // final String title;
  // final String imageUrl;

  // kalo gaada {} berarti positional arguments
  /// kalo ada {} berarti named arguments
  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    
    // the widget doesnt rebuilt if the product changes if set
    // listem argument to false
    final product = Provider.of<Product>(context, listen: false);
    // the widget doesnt rebuilt if the cart changes if set
    // listem argument to false
    final cart = Provider.of<CartProvider>(context, listen: false);
    /// ClipRRect force the child widget it wraps into
    /// a certain shape 
    /// it helps us with clipping a rectangle to add rounded corner
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      /// GridTile mirip ListTile (?)
      child: GridTile(
        // child contains the main content of gridtile
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id
            );
          },
          /// Hero is animation when we click the image on productitem
          child: Hero(
            /// tag is is used on the new page which is loaded
            /// because the hero animation is always used between
            /// two different page, two different screens
            /// its used on new screen which is loaded to know which image on
            /// the old screen to float over so to say, which image should be
            /// animated
            /// we also use hero on product detail screen
            tag: product.id, // tag should be unique
            child: FadeInImage(
              /// show image placeholder when loading image
              placeholder: AssetImage('asset/img/product-placeholder.png'), 
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          )
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    product.toggleFavorite(
                      authData.token,
                      authData.userId  
                    );
                  },
                ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart), 
            onPressed: () {
              cart.addCartItem(
                product.id, 
                product.price, 
                product.title
              );
              /// show pop up
              /// establish a connection to the nearest scaffold with
              /// nearest scaffold widget with syntax "of(context)"
              // hide current snackbar if we want to show snackbar immediately
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                    // textAlign: TextAlign.center,
                  ),
                  duration: Duration(minutes: 2), // 2 seconds for showing snackbar
                  action: SnackBarAction(
                    label: 'UNDO', 
                    onPressed: () {
                      cart.removeCartItemAddition(product.id);
                    }
                  ),
                )
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
    // return Consumer<Product>(
    //   /// Consumer<Product> equal to Provider.of<Product>(context)
    //   /// consumer is a generic type, we should provide which type of data 
    //   /// we want to consume. in this case, we want to consume Product
    //     builder: (ctx, product, child) => 
    //               ClipRRect(
    //               borderRadius: BorderRadius.circular(10),
    //               /// GridTile mirip ListTile (?)
    //               child: GridTile(
    //                 // child contains the main content of gridtile
    //                   child: GestureDetector(
    //                     onTap: () {
    //                       Navigator.of(context).pushNamed(
    //                         ProductDetailScreen.routeName,
    //                         arguments: product.id
    //                       );
    //                     },
    //                     child: Image.network(
    //                       product.imageUrl,
    //                       fit: BoxFit.cover,
    //                     ),
    //                   ),
    //                   footer: GridTileBar(
    //                     backgroundColor: Colors.black87,
    //                     leading: IconButton(
    //                       icon: Icon( 
    //                         product.isFavorite ? Icons.favorite
    //                                               : Icons.favorite_border
    //                       ), 
    //                       onPressed: () {
    //                         // set favorite status
    //                         product.toggleFavorite();
    //                       },
    //                       color: Theme.of(context).accentColor,
    //                     ),
    //                     title: Text(
    //                       product.title,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                     trailing: IconButton(
    //                       icon: Icon(Icons.shopping_cart), 
    //                       onPressed: () {},
    //                       color: Theme.of(context).accentColor,
    //                     ),
    //                   ),
    //               ),
    //             ),
    // );
  }
}