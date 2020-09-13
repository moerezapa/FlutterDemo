import 'package:flutter/material.dart';

import '../screen/filters_screen.dart';

class MainDrawer extends StatelessWidget {

  Widget _buildListTile(IconData iconTile, String label, Function tapHandler) {
    return ListTile(
      leading: Icon(
        iconTile,
        size: 26,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold
        ),
      ),
      onTap: tapHandler,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            // alignment control how the child is aligned
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Text(
              'Cooking Up!',
              style: TextStyle(
                // gausah nyantumin fontfamily karena font yg weight 900 itu Raleway doang
                fontWeight: FontWeight.w900,
                fontSize: 30,
                color: Theme.of(context).primaryColor
              ),
            ),
          ),

          SizedBox( height: 20,),

          _buildListTile(
            Icons.restaurant, 
            'Meals',
            () {
              Navigator.of(context).pushReplacementNamed('/');
            }
          ),

          _buildListTile(
            Icons.settings, 
            'Filters',
            () {
              Navigator.of(context).pushReplacementNamed(FilterScreen.routeName);
            }
          ),

        ],
      ),
    );
  }
}