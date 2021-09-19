
import 'dart:io';

import 'package:ads_platform/categories_screens/cars_screen.dart';
import 'package:ads_platform/categories_screens/closes_screen.dart';
import 'package:ads_platform/categories_screens/pc_screen.dart';
import 'package:ads_platform/categories_screens/phones_screen.dart';
import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/screens/image_pick_screen.dart';
import 'package:ads_platform/ui/button_decoration.dart';
import 'package:ads_platform/ui/colors.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';


class NewAd extends StatefulWidget {
  static const id = 'new_ads';
  final File? file1;
  final File? file2;
  final File? file3;

  String? titletext;
  String? pricetext;
  String? phonetext;
  String? desctext;

    String? url;
    String? url2;
    String? url3;

  NewAd(this.file1,this.file2,this.file3,this.titletext,this.pricetext,this.phonetext,this.desctext);

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
  String currentcurreny = 'USD';
  String categoryCurrentCity = 'Kiev';
  String ukrname = 'Ukraine';
  String phonecode = '+380';
  bool isloading = false;
  String countryvalue = '';
  String countrycode = '';
  String cityvalue = '';
  String statevalue = '';

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
      'location': '$ukrname,$categoryCurrentCity',
      'currency' : currentcurreny,
      'city' : categoryCurrentCity,
      'phone' : '$phonecode${phonecontroller.text}',
      'price' : "${pricecontroller.text} $currentcurreny",
      'desc'  : desccontroller.text,
      'url1'  : widget.url,
      'viewcount' : 0,
      'url2'  : widget.url2,
      'url3'  : widget.url3,
      'category'  : categoryCurrentItem,
      'userid'  : user != null? user!.uid : googleUser!.id,
      'time'   : Timestamp.now()
    });

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
    @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pushNamed(context, HomePage.id);
          }, icon: Icon(Icons.arrow_back)),
          title: Text('New Add'),
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
                                  child: widget.file1 == null? IconButton(onPressed: (){
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePick(null, null, null,widget.titletext,widget.pricetext,widget.phonetext, widget.desctext)));
                                  }, icon: Icon(Icons.add,size: 40,color: MyColors.navy[400],)) : PageView(
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
                                 widget.titletext = titlecontroller.text;
                                 widget.phonetext = phonecontroller.text;
                                 widget.pricetext = pricecontroller.text;
                                 widget.desctext = desccontroller.text;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ImagePick(widget.file1, widget.file2, widget.file3,widget.titletext,widget.pricetext,widget.phonetext, widget.desctext)));
                              }, child: Text('Edit Photos')) ,
                              SizedBox(height: 20.0,),
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Container(
                                     width: double.maxFinite,
                                     child: TextFormField(
                                       maxLength: 20,
                                       validator: validatorone,
                                       controller: titlecontroller,
                                      decoration: textnewaddfielddecoration,
                                ),
                                   ),
                                 ),
                              SizedBox(height: 8.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16,bottom:16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: DropdownButton(
                                    value: categoryCurrentItem,
                                       icon: Icon(Icons.arrow_drop_down_circle,color: Colors.green,),
                                      isExpanded: true,
                                      iconSize: 30,
                                      elevation: 15,
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                      underline: Container(
                                        color: MyColors.navy[100],
                                        width: 150,
                                        height: 2,
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
                                        value: currentcurreny,
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                        onChanged: (String? value) {
                                          setState(() {
                                            currentcurreny = value!;
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
                                          validator: validatorprice,
                                          controller: pricecontroller,
                                          keyboardType: TextInputType.number,
                                          decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Price', labelText: 'Price',),
                                    ),
                                       ),
                                     ),

                                ],
                              ),

                              SizedBox(height: 15.0,),


                              Row(
                                  children: [
                                       Expanded(
                                         child: Padding(
                                           padding: const EdgeInsets.all(8.0),
                                           child: TextFormField(
                                             initialValue: phonecode,style: TextStyle(fontWeight: FontWeight.w400),
                                             enabled: false,
                                             decoration: textdef,
                                           )
                                         ),
                                       ),

                                       Expanded(
                                         child: Padding(
                                           padding: const EdgeInsets.only(right: 8.0,top: 18.0),
                                           child: TextFormField(
                                            validator: validatorone,
                                            controller: phonecontroller,
                                            maxLength: 13,
                                            keyboardType: TextInputType.phone,
                                            decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Phone', labelText: 'Phone'),
                                      ),
                                         ),
                                       ),
                                  ],
                                ),


                              SizedBox(height: 15.0,),

                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: false,
                                        initialValue: ukrname,style: TextStyle(fontWeight: FontWeight.w400) ,
                                        decoration: textdef,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Padding(
                                      child: DropdownButton(
                                         isExpanded: true,
                                          icon: Icon(Icons.arrow_drop_down,color: Colors.green,),
                                          underline: Container(
                                            color: MyColors.navy[100],
                                            width: 150,
                                            height: 2,
                                          ),
                                          value: categoryCurrentCity,
                                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                          onChanged: (String? value) {
                                            setState(() {
                                              categoryCurrentCity = value!;
                                            });
                                          },
                                          items: cityList.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          )).toList()),
                                      padding: EdgeInsets.all(8.0))),
                                ],
                              ),

                                  /*CSCPicker(
                                   showCities: true,
                                    showStates: true,
                                    dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.white,
                                        border:
                                        Border.all(color: Colors.grey.shade300, width: 1)),

                                    ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                                    disabledDropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Colors.grey.shade300,
                                        border:
                                        Border.all(color: Colors.grey.shade300, width: 1)),

                                    selectedItemStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    onCountryChanged: (value){
                                      countryvalue = value;
                                     print('$countryvalue');
                                    },
                                    onCityChanged: (value){
                                      cityvalue = value?? '';
                                      print('$cityvalue');
                                    },

                                    onStateChanged: (value){
                                      statevalue  = value?? '';
                                      print('$cityvalue');
                                    },

                                  ),*/
                                 /* SelectState(

                                    onCountryChanged: (String value) {
                                      setState(() {
                                        countryvalue = value;
                                      });


                                  },  onCityChanged: (String value) {
                                    cityvalue = value;
                                  },
                                     onStateChanged: (String value) {
                                    setState(() {
                                     statevalue = value;
                                               });
                                              })*/
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 16,bottom:16),
                                child: Container(
                                  width: double.maxFinite,
                                  child: TextFormField(
                                    validator: validatortwo,
                                    controller: desccontroller,
                                    maxLength: 200,
                                    maxLines: 12,
                                    decoration: textnewaddfielddecoration.copyWith(hintText: 'Enter Description', labelText: 'Description'),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0,),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(width: 300,
                                    height: 60,
                                    child: Buttons(Colors.green, 'Publish', ()async{
                                      if(_key.currentState!.validate()) {
                                        final snackbar = SnackBar(
                                            content: Text('Add published successfully'));
                                        final snackbarerror = SnackBar(
                                            content: Text('Internet connection is lost'));
                                         bool result = await DataConnectionChecker().hasConnection;
                                        setState(() {
                                          isloading = true;
                                          showAlertDialog(context);
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

                                    }, TextStyle(color: Colors.white,fontSize: 20))),
                              )
                            ],
                          ),
                      ),
          ),
             ),
        )
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