import 'package:flutter/material.dart';

class FullImage extends StatelessWidget {
  String url1;
  String url2;
  String url3;


  FullImage(this.url1, this.url2, this.url3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Image'),),
      body: Container(
        child:
        /*Align( alignment: Alignment.topLeft,
              child: IconButton(onPressed: () => Navigator.of(context).pop, icon: Icon(Icons.backspace_rounded))),*/
            PageView(
              children: [
                Image.network(url1,fit: BoxFit.cover,height: double.infinity,),
                Image.network(url2,fit: BoxFit.cover,height: double.infinity,),
                Image.network(url3,fit: BoxFit.cover,height: double.infinity,),
              ],
            ),

      ),
    );
  }
}
