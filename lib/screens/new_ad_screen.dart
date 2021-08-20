
import 'dart:io';

import 'package:ads_platform/categories_screens/cars_screen.dart';
import 'package:ads_platform/categories_screens/closes_screen.dart';
import 'package:ads_platform/categories_screens/pc_screen.dart';
import 'package:ads_platform/categories_screens/phones_screen.dart';
import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/screens/image_pick_screen.dart';
import 'package:ads_platform/ui/button_decoration.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class NewAd extends StatefulWidget {
  static const id = 'new_ads';
  final File? file1;
  final File? file2;
  final File? file3;

    String? url;
    String? url2;
    String? url3;

  NewAd(this.file1,this.file2,this.file3);

  @override
  _NewAdState createState() => _NewAdState();
}

class _NewAdState extends State<NewAd> {

  final firebase_storage = FirebaseStorage.instance;
  final titlecontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final desccontroller = TextEditingController();
  CollectionReference ads = FirebaseFirestore.instance.collection('ads');
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);


  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String categoryCurrentItem = 'Cars';
  bool isloading = false;
  List<String> categoryList = <String>[
    'Cars',
    'Closes',
    'Smartphones',
    'PC'
  ];

  void CheckCategory(){
    if(categoryCurrentItem == 'Smartphones'){
      ads.
      where('category', isEqualTo: 'Smartphones')
          .get().then((value) => Navigator.pushNamed(context, PhonesScreen.id));
      
    } else if(categoryCurrentItem == 'Cars'){
      ads.
      where('category', isEqualTo: 'Cars')
          .get().then((value) => Navigator.pushNamed(context, CarsScreen.id));
    }
    else if(categoryCurrentItem == 'PC'){
      ads.
      where('category', isEqualTo: 'PC')
          .get().then((value) => Navigator.pushNamed(context, PcScreen.id));
    }
    else if(categoryCurrentItem == 'Closes'){
      ads.
      where('category', isEqualTo: 'Closes')
          .get().then((value) => Navigator.pushNamed(context, ClosesScreen.id));
    }
  }

  Future newAdd() async{
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    String fileName = widget.file1!.path;
    var reference = firebase_storage.ref().child('imagemain/$fileName');
    var uploadtask = reference.putFile(widget.file1!);
    var imageUrl = await (await uploadtask).ref.getDownloadURL();
    widget.url = imageUrl.toString();
    print(widget.url);

    String fileName2 = widget.file2!.path;
    var reference2 = firebase_storage.ref().child('image2/$fileName2');
    var uploadtask2 = reference2.putFile(widget.file2!);
    var imageUrl2 = await (await uploadtask2).ref.getDownloadURL();
    widget.url2 = imageUrl2.toString();
    print(widget.url2);

    String fileName3 = widget.file3!.path;
    var reference3 = firebase_storage.ref().child('image3/$fileName3');
    var uploadtask3 = reference3.putFile(widget.file3!);
    var imageUrl3 = await (await uploadtask3).ref.getDownloadURL();
    widget.url3 = imageUrl3.toString();
    print(widget.url3);

    return ads.add({
      'title' : titlecontroller.text,
      'phone' : phonecontroller.text,
      'price' : pricecontroller.text,
      'desc'  : desccontroller.text,
      'url1'  : widget.url,
      'url2'  : widget.url2,
      'url3'  : widget.url3,
      'category'  : categoryCurrentItem,
      'userid'  : user != null? user!.uid : googleUser!.id,
      'time'   : Timestamp.now()
    });

  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(context, HomePage.id);
          }, icon: Icon(Icons.backspace_rounded)),
          title: Text('New Add'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isloading,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _key,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.redAccent,
                        height: 150,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: widget.file1 == null? IconButton(onPressed: (){
                            Navigator.pushNamed(context, ImagePick.id);
                          }, icon: Icon(Icons.add,size: 40,)) : PageView(
                            pageSnapping: true,
                           children: [
                             Image.file(widget.file1!),
                             Image.file(widget.file2!),
                             Image.file(widget.file3!),

                           ],
                          ),
                        ),

                      ),
                       if(widget.file1 != null) TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePick(widget.file1, widget.file2, widget.file3)));
                      }, child: Text('Edit Photos')) ,
                      SizedBox(height: 20.0,),
                         TextFormField(
                           validator: validatorone,
                           controller: titlecontroller,
                          decoration: textnewaddfielddecoration,
                        ),
                      SizedBox(height: 8.0,),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DropdownButton(
                            value: categoryCurrentItem,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 15,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              underline: Container(
                                width: 150,
                                height: 2,
                                color: Colors.purple,
                              ),
                              onChanged: (String? value){
                                setState(() {
                                  categoryCurrentItem = value!;
                                });
                              },
                              items: categoryList.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              )).toList()
                   ),
                        ),
                      ),
                      SizedBox(height: 8.0,),
                      TextFormField(
                        validator: validatorprice,
                        controller: pricecontroller,
                        keyboardType: TextInputType.number,
                        decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Price', labelText: 'Price',),
                      ),
                      SizedBox(height: 8.0,),

                      TextFormField(
                        validator: validatorone,
                        controller: phonecontroller,
                        maxLength: 13,
                        keyboardType: TextInputType.phone,
                        decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Phone', labelText: 'Phone'),
                      ),

                      SizedBox(height: 10.0,),

                      TextFormField(
                        validator: validatortwo,
                        controller: desccontroller,
                        maxLength: 200,
                        maxLines: 12,
                        decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Description', labelText: 'Description'),
                      ),
                      SizedBox(height: 8.0,),
                      SizedBox(width: 150,
                          height: 50,
                          child: Buttons(Colors.deepPurple, 'Publish', ()async{
                            if(_key.currentState!.validate()) {
                              final snackbar = SnackBar(
                                  content: Text('Add published successfully'));
                              final snackbarerror = SnackBar(
                                  content: Text('Internet connection is lost'));
                               bool result = await DataConnectionChecker().hasConnection;
                              setState(() {
                                isloading = true;
                              });
                              try {
                                if(result==true) {
                                  await newAdd();
                                  CheckCategory();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackbar);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackbarerror);
                                }
                              }
                              on FirebaseException catch (e) {
                                print(e);
                              }
                              Future.delayed(Duration(seconds: 3), (){
                                setState(() {
                                  isloading = !isloading;
                                });
                              });
                            }

                          }, TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }
}

String? validatorone(String? formvalidator){
  if(formvalidator!.isEmpty || formvalidator.length < 5 ){
    return 'Title must have no less than 5 letters';
  }

  return null;


}
String? validatorprice(String? formvalidator){
  if(formvalidator!.isEmpty || formvalidator.length < 1 ){
    return 'Title must have no less than 1 letters';
  }

  return null;


}

String? validatortwo(String? formvalidator){
  if(formvalidator!.isEmpty || formvalidator.length < 20 ){
    return 'Description must have no less than 20 letters';
  }

  return null;


}