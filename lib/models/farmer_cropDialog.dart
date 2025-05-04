import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> farmerCropDialog(BuildContext context, filePath) async {
  return await showDialog(
      context: context,
      builder: (context) {
        final _cropController = CropController();
        Uint8List? _croppedData;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            actionsPadding: EdgeInsets.all(14),
            title: Text('Crop a photo'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              width: 720,
              child: Crop(
                controller: _cropController,
                aspectRatio: 1 / 1,
                image: File(filePath).readAsBytesSync(),
                baseColor: Colors.transparent,
                maskColor: Colors.white.withAlpha(100),
                onCropped: (croppedData) {
                  setState(() {
                    _croppedData = croppedData as Uint8List?;
                  });
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(fixedSize: Size(76, 36)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          content: SizedBox(
                            width: 720,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      });
                  _cropController.crop();
                  Future.delayed(Duration(seconds: 1)).whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pop(context, _croppedData);
                  });
                },
                child: Text('Done'),
              ),
            ],
          );
        });
      }).then((value) async {
    if (value == null) {
      return 'Cancel';
    }
    // final responseFireStorage = await http.post(
    //   //https://firebasestorage.clients6.google.com/v0/b/coun-ab246.appspot.com/o
    //   //https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=g.jpg
    //   //http://localhost:9199/v0/b/default-bucket/o
    //   Uri.parse(
    //       'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o?name=agrigoDir%2FfarmerProfilePictures%2F$farmerNumber.jpg'),
    //   headers: <String, String>{
    //     'Content-Type': 'image/jpeg',
    //   },
    //   body: value,
    // );
    //return 'https://firebasestorage.googleapis.com/v0/b/coun-ab246.appspot.com/o/agrigoDir%2FfarmerProfilePictures%2F${jsonDecode(responseFireStorage.body)['name'].split("/")[2]}?alt=media';
    return value;
  });
}
