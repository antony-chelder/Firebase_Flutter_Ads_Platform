import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Buttons extends StatelessWidget {
  final Color color;
  final String title;
  final void Function() Pressed;
  final TextStyle style;


  Buttons(this.color, this.title, this.Pressed,this.style);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
       child: Material(
         borderRadius: BorderRadius.circular(8.0),
         elevation: 7.0,
         color: color ,
         child: MaterialButton(
           onPressed: Pressed,
            minWidth: 200.0,
            height: 45,
           child: Text(title,style:style),
         ),
       ),

    );
  }
}
