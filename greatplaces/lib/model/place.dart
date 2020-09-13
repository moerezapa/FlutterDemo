import 'dart:io';

import 'package:flutter/foundation.dart';

// class for store location
class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLocation({
    @required this.latitude,
    @required this.longitude,
    this.address
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image; // File need dart:io library

  Place({
    @required this.id,
    @required this.title,
    @required this.location,
    @required this.image
  });
}