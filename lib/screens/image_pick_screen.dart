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

 String? titletext;
 String? pricetext;
 String? phonetext;
 String? desctext;


 ImagePick(this._imagefile, this._imagefile1, this._imagefile2,this.titletext,this.pricetext,this.phonetext,this.desctext);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {

  final ImagePicker picker = ImagePicker();


  Future pickFirstImage() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 15);

    setState(() {
      widget._imagefile = File(pickedFile!.path);
    });


  }
  Future pickSecondImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 15);

    setState(() {
      widget._imagefile1 = File(pickedFile!.path);
    });

  }
    Future pickThirdImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 15);

      setState(() {
        widget._imagefile2 = File(pickedFile!.path);
      });
    }

  showAlertDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(right: 10.0) ),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Please wait...",style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    bool isloading = false;
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
                    Icon(Icons.add_box_rounded,color: Colors.white,size: 40),
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
                    Icon(Icons.add_box_rounded,color: Colors.white,size: 40),
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
                    Icon(Icons.add_box_rounded,color: Colors.white,size: 40,),
                    onPressed: (){
                      pickThirdImage();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:  FloatingActionButton(onPressed: (){
        if(widget._imagefile != null && widget._imagefile1 != null && widget._imagefile2 != null) {
          setState(() {
            isloading = true;
            showAboutDialog(context: context);
          });
          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>

              NewAd(
                  widget._imagefile,
                  widget._imagefile1,
                  widget._imagefile2,
                  widget.titletext,
                  widget.pricetext,
                  widget.phonetext,
                  widget.desctext)));
          setState(() {
            isloading = !isloading;
          });
        } else {
          final snackbar = SnackBar(content: Text('You must choose all 3 photos to confirm'));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      }, child: Icon(Icons.check,color: Colors.white,)));
  }
}
