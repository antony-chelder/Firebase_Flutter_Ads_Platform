import 'package:flutter/material.dart';




const textfielddecoration = InputDecoration(
  prefixIcon: Icon(Icons.email),
  hintText: 'Enter Email',
  contentPadding: EdgeInsets.symmetric(vertical: 12.0,horizontal:5.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0))
  ),
    enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.purpleAccent,width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0))
)

);

const boxdecoration = BoxDecoration(
  borderRadius: BorderRadius.all(Radius.circular(20.0)),
  gradient: LinearGradient(
      colors: [Colors.purple, Colors.purpleAccent],stops: [0.0,1.0],
      tileMode: TileMode.clamp,
      begin: FractionalOffset(0, 1),
  )


  );

const textnewaddfielddecoration = InputDecoration(
  hintText: 'Enter title',
  labelText: 'Title',
  contentPadding: EdgeInsets.all(20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.elliptical(15, 15)),
  ),
  enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.purpleAccent,width: 2.0),
    borderRadius: BorderRadius.all(Radius.elliptical(15, 15))

));





