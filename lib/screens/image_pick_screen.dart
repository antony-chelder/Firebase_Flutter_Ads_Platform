import 'dart:io';

import 'package:ads_platform/screens/new_ad_screen.dart';
import 'package:flutter/material.dart';

import 'package:ads_platform/ui/constants_ui.dart';
import 'package:image_picker/image_picker.dart';
class ImagePick extends StatefulWidget {
 static const id = 'image_pick';
 File? _imagefile;
 File? _imagefile1;
 File? _imagefile2;


 ImagePick(this._imagefile, this._imagefile1, this._imagefile2);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {

  final ImagePicker picker = ImagePicker();


  Future pickFirstImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      widget._imagefile = File(pickedFile!.path);
    });


  }
  Future pickSecondImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      widget._imagefile1 = File(pickedFile!.path);
    });

  }
    Future pickThirdImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        widget._imagefile2 = File(pickedFile!.path);
      });
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Images'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: 200,
                  decoration: boxdecoration,
                  child: IconButton(
                    icon: widget._imagefile != null ? Image.file(widget._imagefile!) :
                    Icon(Icons.add_box_rounded),
                    onPressed: (){
                      pickFirstImage();
                    },
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  height: 200,
                  width: 200,
                  decoration: boxdecoration,
                  child:
                  IconButton(
                    icon: widget._imagefile1 != null ? Image.file(widget._imagefile1!) :
                    Icon(Icons.add_box_rounded),
                    onPressed: (){
                      pickSecondImage();
                    },
                  ),
                ),
                SizedBox(height: 16,),

                Container(
                  height: 200,
                  width: 200,
                  decoration: boxdecoration,
                  child: IconButton(
                    icon: widget._imagefile2 != null ? Image.file(widget._imagefile2!) :
                    Icon(Icons.add_box_rounded),
                    onPressed: (){
                      pickThirdImage();
                    },
                  ),
                ),
                SizedBox(height: 16,),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NewAd(widget._imagefile,widget._imagefile1,widget._imagefile2)));
                }, child: Text('Confirm'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
