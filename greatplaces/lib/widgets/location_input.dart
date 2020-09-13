import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  // variable to store link that point to location
  String _previewImageUrl;

  Future<void> _getCurrentUserLocation() async {
    // locData will return latitude and longitude of location
    final locData = await Location().getLocation();
    print('Latitude at $locData.latitude');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // map preview
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
            ?
              Text('No location chosen', textAlign: TextAlign.center,)
            :
              Image.network(
                _previewImageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
        ),
        // button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on), 
              label: Text('Your Current Location'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {}, 
            ),
            FlatButton.icon(
              icon: Icon(Icons.map), 
              label: Text('Select from Map'),
              textColor: Theme.of(context).primaryColor,
              onPressed: () {}, 
            )
          ],
        )
      ],
    );
  }
}