import 'dart:io';

import 'package:ads_platform/screens/edit_screen.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateImagePick extends StatefulWidget {
  File? _imagefile;
  File? _imagefile1;
  File? _imagefile2;


  String? url1;
  String? url2;
  String? url3;

  DocumentSnapshot? doc;


  UpdateImagePick(this._imagefile, this._imagefile1, this._imagefile2, this.url1, this.url2,this.url3,this.doc);

  @override
  _UpdateImagePickState createState() => _UpdateImagePickState();
}

class _UpdateImagePickState extends State<UpdateImagePick> {
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
                  child: InkWell(
                      child:  widget._imagefile != null ? Image.file(widget._imagefile!) :
                      Image.network(widget.url1!),
                      onTap: (){
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
                    Image.network(widget.url2!),
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
                    Image.network(widget.url3!),
                    onPressed: (){
                      pickThirdImage();
                    },
                  ),
                ),
                SizedBox(height: 16,),
                ElevatedButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  EditAdd(null, null, null, null,widget.doc,widget.url1, widget.url2, widget.url3, widget._imagefile, widget._imagefile1, widget._imagefile2)));
                }, child: Text('Confirm'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
