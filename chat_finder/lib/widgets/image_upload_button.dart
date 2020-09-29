import 'dart:io';

import 'package:chat_finder/provider/image_upload_provider.dart';
import 'package:chat_finder/resources/firebase_repository.dart';
import 'package:chat_finder/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadButton extends StatefulWidget {
  @override
  _ImageUploadButtonState createState() => _ImageUploadButtonState();
}

class _ImageUploadButtonState extends State<ImageUploadButton> {
  String imagePath = "";
  FirebaseRepository _repository = FirebaseRepository();
  ImagePicker picker = ImagePicker();
  ImageUploadProvider _imageUploadProvider = ImageUploadProvider();

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Container(
        width: 200,
        height: 200,
        child:  imagePath == ""
            ? Icon(Icons.person)
            : Image(image: NetworkImage(imagePath)),
      ),
      onPressed: () {
        pickImage(source: ImageSource.gallery);
        },
    );
  }

  pickImage({@required ImageSource source}) async {
    File chosenImage = await picker.getImage(source: source).then((file) => File(file.path));
    File compressedImage = await Utils.compressImage(chosenImage);
    String url = await _repository.uploadProfileImage(
      image: compressedImage,
      imageUploadProvider: _imageUploadProvider,
    );
    setState(() {
      imagePath = url;
    });
  }
}
