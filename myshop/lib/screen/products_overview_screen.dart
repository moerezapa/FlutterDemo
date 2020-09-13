import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../widget/product_grid.dart';
import '../widget/badge.dart';
import '../provider/product_provider.dart';
import '../provider/cart_provider.dart';
import '../screen/cart_screen.dart';

enum popupItem {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {

  static const routeName = '/product-overview-screen';
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;
  /**
   * Alternate way of using Provider when first open page
   * 1.
   * put Future.delayed(Duration.zero)
            .then((_) {
              < YOUR PROVIDER >
            });
   * 2. put on didChangeDependencies because that method will run after 
   * the widget fully executed
   * also you need variable helper that check you running first time
   * or not
   */
  @override
  void initState() {
    // Provider.of<ProductProvider>(context).fetchAndSetProducts(); // THIS WON'T WORK!!
    // this is a helper which executes after some duration
    // Future.delayed(Duration.zero)
    //         .then((_) {
    //           Provider.of<ProductProvider>(context).fetchAndSetProducts();
    //         });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // check if this running for the first time
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductProvider>(context)
                .fetchAndSetProducts()
                  .then((_) {
                    setState(() {
                      _isLoading = false;
                    });
                  });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          // drop over menu button
          PopupMenuButton(
            onSelected: (popupItem selectedValue) {
              setState(() {
                if(selectedValue == popupItem.Favorites) {
                  _showOnlyFavorites = true;
                }
                  else {
                    _showOnlyFavorites = false;
                  }
              });
            },
            // itemBuilder build the entire menu in this popup menu
            // (_) artinya nggak terlalu meduliin data apa yang di passing (?)
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                // for finding out which PopupMenuItem was chosen
                value: popupItem.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                // for finding out which PopupMenuItem was chosen
                value: popupItem.All,
              )
            ],
            icon: Icon(Icons.more_vert),
          ),

          /// karena cuman widget ini aja yang butuh provider,
          /// manggil providernya disini aja
          Consumer<CartProvider> (
            builder: (_, cartData, ch) => 
                      Badge(
                        child: ch, 
                        value: cartData.cartItemCount.toString()
                      ),
                      child: IconButton(
                          icon: Icon(Icons.shopping_cart), 
                          onPressed: () {
                            Navigator.of(context).pushNamed(CartScreen.routeName);
                          }
                      ),
          ) 
        ],
      ),

      drawer: AppDrawer(),

      body: _isLoading
            ? Center(
              child: CircularProgressIndicator(),
            )
            : ProductsGrid(_showOnlyFavorites), // gausah argument ngeload product, cukup make provider
    );
  }
}

