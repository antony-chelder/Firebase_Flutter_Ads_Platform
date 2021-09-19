import 'dart:io';

import 'package:ads_platform/categories_screens/cars_screen.dart';
import 'package:ads_platform/categories_screens/closes_screen.dart';
import 'package:ads_platform/categories_screens/pc_screen.dart';
import 'package:ads_platform/categories_screens/phones_screen.dart';
import 'package:ads_platform/screens/update_image_pick.dart';
import 'package:ads_platform/ui/button_decoration.dart';
import 'package:ads_platform/ui/colors.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';


class EditAdd extends StatefulWidget {
  String? titletext;
  String? pricetext;
  String? phonetext;
  String? desctext;
  String? country;
  String? city;
  String? state;
  String? currency;
  String? countrycode;
  String? currentcat;


  String? url1;
  String? url2;
  String? url3;


  File? _imagefile;
  File? _imagefile1;
  File? _imagefile2;

  DocumentSnapshot? doc;

  EditAdd(
      this.titletext,
      this.pricetext,
      this.phonetext,
      this.desctext,
      this.doc,
      this.url1,
      this.url2,
      this.url3,
      this._imagefile,
      this._imagefile1,
      this._imagefile2,
      this.city,
      this.currency,
      this.currentcat
      );



  @override
  _EditAddState createState() => _EditAddState();
}

class _EditAddState extends State<EditAdd> {
  @override
  void initState() {
    print(widget.country);
    print(widget.pricetext);

    super.initState();
  }


  CollectionReference updateads = FirebaseFirestore.instance.collection('ads');

  final firebase_storage = FirebaseStorage.instance;
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String categoryCurrentItem = 'Cars';
  String categoryCurrentCity = 'Kiev';
  String ukrname = 'Ukraine';
  String phonecode = '+380';
  bool isloading = false;
  List<String> categoryList = <String>[
    'Cars',
    'Closes',
    'Smartphones',
    'PC'
  ];

  List<String> currencyList = <String>[
    'USD',
    'RUB',
    'EU',
    'RMB'
  ];

  List<String> cityList = <String>[
    'Kiev',
    'Donetsk',
    'Harkiv',
    'Poltava'
  ];

  void CheckCategory(){
    if(categoryCurrentItem == 'Smartphones'){
      updateads.
      where('category', isEqualTo: 'Smartphones')
          .get().then((value) => Navigator.pushNamed(context, PhonesScreen.id));

    } else if(categoryCurrentItem == 'Cars'){
      updateads.
      where('category', isEqualTo: 'Cars')
          .get().then((value) => Navigator.pushNamed(context, CarsScreen.id));
    }
    else if(categoryCurrentItem == 'PC'){
      updateads.
      where('category', isEqualTo: 'PC')
          .get().then((value) => Navigator.pushNamed(context, PcScreen.id));
    }
    else if(categoryCurrentItem == 'Closes'){
      updateads.
      where('category', isEqualTo: 'Closes')
          .get().then((value) => Navigator.pushNamed(context, ClosesScreen.id));
    }
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(),
          Padding(padding: EdgeInsets.only(right: 10.0) ),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading...",style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),)),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Future UpdateAdd() async {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    if(widget._imagefile != null) {
      String fileName = widget._imagefile!.path;
      var reference = firebase_storage.ref().child('imagemain/$fileName');
      var uploadtask = reference.putFile(widget._imagefile!);
      var imageUrl = await (await uploadtask).ref.getDownloadURL();
      widget.url1 = imageUrl.toString();
      print(widget.url1);
    }

    if(widget._imagefile1 != null) {
      String fileName2 = widget._imagefile1!.path;
      var reference2 = firebase_storage.ref().child('image2/$fileName2');
      var uploadtask2 = reference2.putFile(widget._imagefile1!);
      var imageUrl2 = await (await uploadtask2).ref.getDownloadURL();
      widget.url2 = imageUrl2.toString();
      print(widget.url2);
    }
    if(widget._imagefile2 != null) {
      String fileName3 = widget._imagefile2!.path;
      var reference3 = firebase_storage.ref().child('image3/$fileName3');
      var uploadtask3 = reference3.putFile(widget._imagefile2!);
      var imageUrl3 = await (await uploadtask3).ref.getDownloadURL();
      widget.url3 = imageUrl3.toString();
      print(widget.url3);
    }
    return widget.doc!.reference.set({
      'title' : widget.titletext,
      'phone' : widget.phonetext,
       'location': '$ukrname,$categoryCurrentCity',
      'price' : widget.pricetext,
      'city' : categoryCurrentCity,
      'currency' : widget.currency,
      'url1'  : widget.url1,
      'url2'  : widget.url2,
      'url3'  : widget.url3,
      'desc'  : widget.desctext,
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
            }, icon: Icon(Icons.arrow_back)),
            title: Text('Edit Ad'),
          ),
          body: Padding(
              padding: const EdgeInsets.only(top: 16.0,right: 8.0,left : 8.0,bottom :8.0),
              child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              border: Border.all(color : Colors.green)
                            ),
                            height: 180,
                            width: 320,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PageView(
                                pageSnapping: true,
                                children: [
                                  widget._imagefile != null? Image.file(widget._imagefile!)  : Image.network(widget.url1!),
                                  widget._imagefile1 != null? Image.file(widget._imagefile!)  : Image.network(widget.url2!),
                                  widget._imagefile2 != null? Image.file(widget._imagefile!)  : Image.network(widget.url3!),
                                ]

                                ,
                              ),
                            ),

                          ),
                          SizedBox(height: 8.0,),
                          TextButton(onPressed: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => UpdateImagePick(widget._imagefile, widget._imagefile1, widget._imagefile2, widget.url1, widget.url2, widget.url3,widget.doc,widget.titletext,widget.pricetext,widget.phonetext,widget.desctext,widget.city,widget.currency,widget.currentcat)));
                          }, child: Text('Choose another photos')),
                          SizedBox(height: 20.0,),
                          TextFormField(
                            initialValue: widget.titletext,
                            validator: validatorone,
                            decoration: textnewaddfielddecoration,
                            onChanged: (value){
                              widget.titletext = value;
                            },
                          ),
                          SizedBox(height: 8.0,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16,bottom:16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButton(
                                  isExpanded: true,
                                  value: widget.currentcat,
                                  icon: Icon(Icons.arrow_drop_down_circle,color: Colors.green,),
                                  iconSize: 30,
                                  elevation: 15,
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  underline: Container(
                                    width: 150,
                                    height: 2,
                                    color: MyColors.navy[100],
                                  ),
                                  onChanged: (String? value){
                                    setState(() {
                                      widget.currentcat = value!;
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
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                            icon: Icon(Icons.arrow_drop_down,color: Colors.green,),
                            underline: Container(
                              color: MyColors.navy[100],
                              width: 150,
                              height: 2,
                            ),
                            value: widget.currency,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            onChanged: (String? value) {
                              setState(() {
                                widget.currency = value!;
                              });
                            },
                            items: currencyList.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            )).toList()),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: widget.pricetext,
                          validator: validatorprice,
                          onChanged: (value){
                            widget.pricetext = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Price', labelText: 'Price',),
                        ),
                      ),
                    ),
                  ],
                ),
                          SizedBox(height: 8.0,),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: phonecode ,
                          decoration: textdef,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          initialValue: widget.phonetext,
                          validator: validatorone,
                          maxLength: 13,
                          onChanged: (value){
                            widget.phonetext = value;
                          },
                          keyboardType: TextInputType.phone,
                          decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Phone', labelText: 'Phone'),
                        ),
                      ),
                    ),
                          ],
                ),
                          SizedBox(height: 10.0,),
                          
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                  TextFormField(
                                    initialValue: ukrname ,
                                    decoration: textdef,
                                  ),
                                ),
                              ),
                              
                              Expanded(child: Padding(
                                  child:DropdownButton(
                              icon: Icon(Icons.arrow_drop_down,color: Colors.green,),
                              underline: Container(
                              color: MyColors.navy[100],
                              width: 150,
                              height: 2,
                              ),
                              value: widget.city,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              onChanged: (String? value) {
                              setState(() {
                              widget.city = value!;
                              });
                              },
                              items: cityList.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                                )).toList()),
                                  padding: EdgeInsets.all(8.0)))
                            ],
                          ),
                          SizedBox(height: 8.0,),

                          TextFormField(
                            initialValue: widget.desctext,
                            validator: validatortwo,
                            onChanged: (value){
                              widget.desctext = value;
                            },
                            maxLength: 200,
                            maxLines: 12,
                            decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Description', labelText: 'Description'),
                          ),
                          SizedBox(height: 8.0,),
                          SizedBox(width: 300,
                                height: 60,
                                child: Buttons(Colors.green, 'Save', ()async{
                                  if(_key.currentState!.validate()) {
                                    final snackbar = SnackBar(
                                        content: Text('Add update successfully'));
                                    final snackbarerror = SnackBar(
                                        content: Text('Internet connection is lost'));
                                    bool result = await DataConnectionChecker().hasConnection;
                                    setState(() {
                                      isloading = true;
                                      showAlertDialog(context);
                                    });
                                    try {
                                      if(result==true) {
                                        await UpdateAdd();
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

                                }, TextStyle(color: Colors.white,fontSize: 20))),
                        ],
                      ),
                    ),
                  ),
              ),
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
