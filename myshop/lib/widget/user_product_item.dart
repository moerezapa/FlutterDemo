import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/edit_product_screen.dart';
import '../provider/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        // image will be loaded as background image of avatar
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        // di wrap ke container karena row make space sebanyak mungkin
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit), 
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: id
                );
              }
            ),
            IconButton(
              icon: Icon(Icons.delete), 
              color: Theme.of(context).errorColor,
              onPressed: () async { // add 'async' so that can work with this Future deleteProduct
                try {
                  await Provider.of<ProductProvider>(
                    context,
                    listen: false
                  ).deleteProduct(id);
                }
                  catch (error) {
                    // show Snackbar
                    print(error);
                    // Scaffold.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text('Deleting failed')
                    //   )
                    // );
                  }
              }
            )
          ],
        ),
      ),
    );
  }
}