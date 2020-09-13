import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './add_place_screen.dart';
import '../provider/greatplace_provider.dart';

class PlaceListScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add), 
            onPressed: () { // move to add place screen
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
              }, 
          )
        ],
      ),

      body: FutureBuilder(
        future: Provider.of<GreatPlaceProvider>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting 
          ?
            Center(child: CircularProgressIndicator())
          :
            Consumer<GreatPlaceProvider>(
              child: Center(
                child: const Text('No places added yet. Let\'s adding some!'),
              ),
              builder: (ctx, greatPlaces, ch) => 
                greatPlaces.items.length <= 0 ?
                  ch
                :
                  ListView.builder(
                    itemCount: greatPlaces.items.length,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: CircleAvatar(
                        backgroundImage: FileImage(greatPlaces.items[index].image),
                      ),
                      title: Text(greatPlaces.items[index].title),
                      onTap: () {},
                    ),
                  )
            ),
      ),
    );
  }
}