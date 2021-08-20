
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Ads extends StatelessWidget {
  String title;
  String price;
  IconButton? delete;
  IconButton? edit;
  String url;


  Ads(this.title, this.price,this.url,this.delete,this.edit);

  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(12.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                 image: DecorationImage(
                    image: NetworkImage(url)
                 )
              ) ,
            ),
            SizedBox(height: 8.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                  color: Colors.purple,
                  child: Text(title,style: TextStyle(color: Colors.white))
              ),
            ),
            SizedBox(height: 10.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Material(
                    color: Colors.purple,
                    child: Text(price,style: TextStyle(color: Colors.white),)
                ),
              ),
            ),
            SizedBox(height: 8.0,),
                     Container(
                         height: 40.0,
                         width: double.infinity,
                         color: Colors.indigo,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           crossAxisAlignment: CrossAxisAlignment.stretch,
                           children: [
                             Align(
                               alignment: Alignment.bottomRight,
                               child: delete
                               ),
                             Padding(padding: EdgeInsets.only(right: 8.0)),
                             Align(
                               alignment: Alignment.bottomLeft,
                               child: edit
                             ),
                           ],
                         )),

                   ],
        ),
      ),
    );

  }
}



