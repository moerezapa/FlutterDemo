import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';
import '../provider/greatplace_provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;

  }
  void _savePlace() {
    if(_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }

    // listen = false because we're not interested in updates in this place
    Provider.of<GreatPlaceProvider>(context, listen: false)
      .addPlace(_titleController.text, _pickedImage);
    // and then leave this page
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Text('Add a new place'),
       ),

       body: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch, // make width of content to full screen (?)
         children: <Widget>[
           /**
            * Expanded will take all the remaining space on the screen,
            * so screen height minus the button
            */
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      
                      TextField(
                        decoration: InputDecoration(labelText: 'Title'),
                        controller: _titleController,
                      ),

                      SizedBox(height: 10,),

                      ImageInput(_selectImage),

                      SizedBox(height: 10,),

                      LocationInput()
                    ],
                  ),
                ),
              ),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.add), 
              label: Text('Add Place'),
              elevation: 0, // remove button's shadow
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // make button really sits on the end of the screen
              color: Theme.of(context).accentColor,
              onPressed: _savePlace
            )
         ],
       ),
    );
  }
}