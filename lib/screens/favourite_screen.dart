
import 'package:ads_platform/ui/add_item_ui.dart';
import 'package:ads_platform/ui/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final userreal = FirebaseAuth.instance.currentUser;
final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
CollectionReference collectionads = FirebaseFirestore.instance.collection('ads');
DocumentReference docref = collectionads.doc();
GoogleSignInAccount? googleUserreal = _googleSignIn.currentUser;
String favuid =  userreal!.uid;



class FavouriteAds extends StatefulWidget {
  static const id = "fav";

  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();


}

class _FavouriteAdsState extends State<FavouriteAds> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> favads = collectionads.where('isfav$favuid',isEqualTo: true,).snapshots();
     return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('Favourite ads'),
        centerTitle: true,
      ),
       body:  StreamBuilder<QuerySnapshot>(
         stream: favads,
         builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
           if(!snapshot.hasData){
             return Center(
               child: CircularProgressIndicator(),
             );
           }
           if(snapshot.connectionState == ConnectionState.waiting){
             return Center(
               child: Text('Loading...'),
             );
           }
           return ListView.builder( itemCount : snapshot.data!.docs.length,itemBuilder: (context,index){
             DocumentSnapshot ads = snapshot.data!.docs[index];
             return Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['desc'],(ads.data() as dynamic)['location'], null, ElevatedButton(
               style: ElevatedButton.styleFrom(primary: Colors.black12),
               onPressed: (){
                 showDialog(context: context, builder: (BuildContext context){
                   return AlertDialog(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                     title: Text('Warning',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                     content: Text('Do you really want to delete ad from favourites?'),
                     actions: [
                       TextButton(onPressed: ()async{
                         String ref = ads.reference.id;
                          await collectionads.doc(ref).update({
                           'isfav$favuid': false
                         });
                         Navigator.of(context).pop();

                       }, child: Text('Yes',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold))),
                       TextButton(onPressed: (){
                         Navigator.of(context).pop();
                       }, child: Text('No',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)) )
                     ],

                   );

                 });
               },
               child: Text('Favourite', style: TextStyle(color: Colors.white,fontSize: 16.0),),
             ),Icon(
               Icons.remove_red_eye,color: MyColors.navy[100],
             ),Text((ads.data() as dynamic)['viewcount'] != null?(ads.data() as dynamic)['viewcount'].toString() : '0',style: TextStyle(color: Colors.white,fontSize: 15),));
           });

         }

       ));
  }
}
