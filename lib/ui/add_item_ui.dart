
import 'package:ads_platform/ui/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Ads extends StatelessWidget {
  String title;
  String price;
  String desc;
  String location;
  ElevatedButton? delete;
  ElevatedButton? edit;
  String url;
  Text? view;
  Icon? eye;



  Ads(this.title, this.price,this.url,this.desc,this.location,this.delete,this.edit,this.eye,this.view);

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
            color: MyColors.navy[50],
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
          Container(
          height: 300,
            width: 190,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(url)
                )
            ) ,
          ),
                  Padding(padding: EdgeInsets.only(right: 16.0)),
                  Flexible(
                    child: Padding( padding: EdgeInsets.only(top: 12.0 ),child: Column(
                      children: [
                        Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                        SizedBox(height: 48.0,),
                        RichText(
                            overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          text: TextSpan(
                            style: TextStyle(color: Colors.black),
                            text: desc
                          ),
                        )],
                    )),
                  ),
                ],
              ),
              SizedBox(height: 16.0,),
              Padding(
                padding: const EdgeInsets.only(top: 8.0,left: 8.0,bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on,color: Colors.red,),
                    SizedBox(width: 8.0,),
                    Text(location,style: TextStyle(color: Colors.black),)

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0,right: 8.0,top: 8.0,left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Цена: ',style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(price,style: TextStyle(color: Colors.black),)

                  ],
                ),
              ),
              SizedBox(height: 8.0,),
                       Container(
                           decoration: BoxDecoration(
                             color: MyColors.navy[400],
                             borderRadius: BorderRadius.all(Radius.circular(4.0))
                           ),
                           height: 60.0,
                           width: double.maxFinite,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: [
                               Padding(
                                   padding: const EdgeInsets.all(8.0),
                                 child: eye,
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(top: 22,left: 8,right: 30),
                                 child: view,
                               ),
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Align(
                                     alignment: Alignment.bottomRight,
                                     child: delete
                                     ),
                                 ),
                               ),
                               SizedBox(width: 8.0,),
                               Expanded(
                                 child: Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Align(
                                     alignment: Alignment.centerLeft,
                                     child: edit
                                   ),
                                 ),
                               ),
                             ],
                           )),

                     ],
          ),
      ),
    );

  }
}



