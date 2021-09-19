import 'package:flutter/material.dart';

class TextButtons extends StatelessWidget {
  final String title;
  final void Function() Pressed;
  final TextStyle style;


  TextButtons(this.title, this.Pressed,this.style);

  @override
  Widget build(BuildContext context) {
    return TextButton(
          onPressed: Pressed,
          child: Text(title,style:style),
        );

  }
}