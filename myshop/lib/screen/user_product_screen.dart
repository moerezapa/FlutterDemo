import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../screen/edit_product_screen.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductProvider>(
      context,
      listen: false
    ).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductProvider>(context);

    // checking if we have infinite loop?
    print('rebuilding');
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add), 
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            } 
          )
        ],
      ),

      // to implement pull to refresh, wrap widget in body
      // into RefreshIndicator 
      /// FUtureBuilder biar nggak harus ngeubah widget keseluruhan sebagai stateful
      /// cukup nge wrap sebagian aja 
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting ?  
        Center(
          child: CircularProgressIndicator(),
        ) :
            RefreshIndicator(
              // onRefresh need Future function
              onRefresh: () => _refreshProduct(context),
              /// wrap Padding widget ke Consumer.of<> biar yang kereload cukup bagian ini aja
              /// biar nggak infinite loop ngeload karena udah ada provider dan futurebuilder
              child: Consumer<ProductProvider>(
                /// builder butuh 3 parameter: context, objek provider, & child
                /// kalo nggak terlalu dibutuhin yang child cukup di _ aja
                builder: (ctx, productData, _) =>  Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productData.items.length,
                    itemBuilder: ( _ , index) =>
                      Column(
                        children: <Widget>[
                          UserProductItem(
                            productData.items[index].id,
                            productData.items[index].title, 
                            productData.items[index].imageUrl
                          ),
                          Divider()
                        ],
                      )
                  )
                ),
              ),
            ),
      ),

      drawer: AppDrawer(),
    );
  }
}