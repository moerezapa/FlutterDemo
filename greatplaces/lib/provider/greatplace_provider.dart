import 'package:flutter/foundation.dart';
import 'dart:io';

import '../model/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaceProvider with ChangeNotifier {
  List<Place> _items = [];

  // retrieve a copy of our items
  List<Place> get items {
    return [..._items];
  }

  void addPlace(String title, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(), 
      title: title, 
      location: null, 
      image: pickedImage
    );

    _items.add(newPlace);
    notifyListeners();
    // save to db
    DBHelper.insert(
      DBHelper.placeDBTable, 
      {
        DBHelper.placeID: newPlace.id, 
        DBHelper.placeTitle: newPlace.title, 
        DBHelper.placeImage: newPlace.image.path
      }
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData(DBHelper.placeDBTable);
    _items = dataList.map((dataItem) => 
      Place(
        id: dataItem['id'], 
        title: dataItem['title'], 
        location: null, 
        image: File(dataItem['image'])
      )
    ).toList();
    notifyListeners();
  }
}