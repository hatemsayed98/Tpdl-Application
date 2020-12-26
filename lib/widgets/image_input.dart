import 'dart:io';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

class ImageMultiple extends StatefulWidget {
  List<File> files = List<File>();
  ImageMultiple(this.files);
  @override
  _ImageMultipleState createState() => new _ImageMultipleState();
}

class _ImageMultipleState extends State<ImageMultiple> {
  List<Asset> images = List<Asset>();
  
  @override
  void initState() {
    super.initState();
  }

  Future getImageFileFromAssets() async {
    for(int i = 0; i < images.length; i++){
       final byteData = await images[i].getByteData();
    final tempFile =File("${(await getTemporaryDirectory()).path}/${images[i].name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );
    widget.files.add(file);
    print(file);
    }
  }

  Future<void> pickImages() async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: "FlutterCorner.com",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }

    setState(() {
      images = resultList;
    });
    getImageFileFromAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          child: images.length != 0
              ? GridView.count(
                  scrollDirection: Axis.horizontal,
                  crossAxisCount: 1,
                  children: List.generate(
                    images.length,
                    (index) {
                      Asset asset = images[index];
                      return AssetThumb(
                        asset: asset,
                        width: 300,
                        height: 300,
                      );
                    },
                  ),
                )
              : Image.asset("assets/no-image-icon-6.png"),
        ),
        RaisedButton.icon(
          onPressed: pickImages,
          icon: Icon(
            Icons.camera_alt_outlined,
            size: 40,
          ),
          label: Text(
            'اختر الصوره',
            textAlign: TextAlign.center,
          ),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}