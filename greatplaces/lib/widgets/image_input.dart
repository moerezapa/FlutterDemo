import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

import 'dart:io'; // handle input-output file in flutter

class ImageInput extends StatefulWidget {
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    // open camera and take picture using this method
    final imageFile = await ImagePicker().getImage(
      // define what your source for the image should be camera or gallery
      source: ImageSource.camera,
      // crop image with this width 
      maxWidth: 600
    );
    // handle if user go back to screen without take picture
    if (imageFile == null) {
      return;
    }
    setState(() {
       // convert imageFile to File format
      _storedImage = File(imageFile.path);
    });

    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await File(imageFile.path).copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          alignment: Alignment.center,
          child: _storedImage != null 
                  ? 
                    Image.file(
                      _storedImage, 
                      fit: BoxFit.cover,
                      width: double.infinity,) 
                  : 
                    Text('No Image Taken', textAlign: TextAlign.center,),
        ),
        SizedBox(width: 10,),
        // make button takes all remaining space, so use expanded
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera), 
            label: Text('Take a Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture
          )
        ),
      ],
    );
  }
}