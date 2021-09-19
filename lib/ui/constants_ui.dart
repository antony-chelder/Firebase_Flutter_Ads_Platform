
import 'package:ads_platform/ui/colors.dart';
import 'package:flutter/material.dart';




const textfielddecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  prefixIcon: Icon(Icons.email,color: Colors.lightGreenAccent,),
  hintText: 'Enter Email',
  contentPadding: EdgeInsets.symmetric(vertical: 16.0,horizontal:5.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0))
  ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green,width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0))
)

);

const boxdecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20.0)),
  gradient: LinearGradient(
      colors: [MyColors.navy, Colors.green],stops: [0.0,1.0],
      tileMode: TileMode.clamp,
      begin: FractionalOffset(0, 1),
  )


  );

const textnewaddfielddecoration = InputDecoration(
  hintText: 'Enter title',
  hintStyle: TextStyle(color: Colors.white70),
  labelText: 'Title',
  labelStyle: TextStyle(color: Colors.green),
  contentPadding: EdgeInsets.all(20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
  ),
  enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.lightGreen,width: 2.0),
    borderRadius: BorderRadius.all(Radius.elliptical(15, 15))

));

const dropdowndecor = BoxDecoration(
        border: Border(top: BorderSide(color: Colors.lightGreen,width: 2.0),right: BorderSide(color: Colors.lightGreen,width: 2.0),left: BorderSide(color: Colors.lightGreen,width: 2.0),bottom: BorderSide(color: Colors.lightGreen,width: 2.0)),
        borderRadius: BorderRadius.all(Radius.elliptical(15, 15))
    );


const textshowad = InputDecoration(
    labelText: 'Title',
    labelStyle: TextStyle(color: Colors.green),
    contentPadding: EdgeInsets.only(left: 40.0,top: 20.0,right: 20.0,bottom: 20.0),
    disabledBorder : OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen,width: 2.0),
      borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
));
const textdef = InputDecoration(
    contentPadding: EdgeInsets.only(left: 40.0,top: 20.0,right: 20.0,bottom: 20.0),
    disabledBorder : OutlineInputBorder(
      borderSide: BorderSide(color: Colors.lightGreen,width: 2.0),
      borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
    ));






