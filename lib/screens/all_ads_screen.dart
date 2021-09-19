import 'package:ads_platform/screens/edit_screen.dart';
import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/screens/show_ad_screen.dart';
import 'package:ads_platform/ui/add_item_ui.dart';
import 'package:ads_platform/ui/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AllAds extends StatefulWidget {
  static const id ='all_ads_screen';


  @override
  _AllAdsState createState() => _AllAdsState();
}


class _AllAdsState extends State<AllAds> {
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  var countview = 0;
  CollectionReference collectionads = FirebaseFirestore.instance.collection('ads');
  final Stream<QuerySnapshot> adsStream = FirebaseFirestore.instance.collection('ads').orderBy('time',descending: true).snapshots();

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    String? favuid = user != null
        ? user?.uid
        : googleUser?.id;
    return WillPopScope(
      onWillPop:()async => false,
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pushNamed(context, HomePage.id);
              },
            ),
            title: Text('All Ads'),
            centerTitle: true,

          ),
          body: StreamBuilder<QuerySnapshot>(
              stream: adsStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
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
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      DocumentSnapshot ads = snapshot.data!.docs[index];
                      final userad = (ads.data()as dynamic)['userid'];
                      return InkWell(
                        onTap: () {
                          if(user?.uid != userad){
                            setState(() {
                              countview = (ads.data()as dynamic)['viewcount'] +1 ;
                            });
                            String ref = ads.reference.id;
                            collectionads.doc(ref).update({
                              'viewcount' : countview

                            });
                          }
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>

                                  ShowAdScreen(
                                      (ads.data() as dynamic)['title'],
                                      (ads.data() as dynamic)['price'],
                                      (ads.data() as dynamic)['phone'],
                                      (ads.data() as dynamic)['desc'],
                                      (ads.data() as dynamic)['category'],
                                      (ads.data() as dynamic)['url1'],
                                      (ads.data() as dynamic)['url2'],
                                      (ads.data() as dynamic)['url3'],
                                      (ads.data() as dynamic)['location']

                                  )
                              ));
                        },
                        child: Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['desc'],
                            (ads.data() as dynamic)['location'],
                            userad == user?.uid || userad ==  googleUser?.id  ?  ElevatedButton(
                              child: Text('Удалить'),
                                onPressed: userad == user?.uid || userad ==  googleUser?.id  ?() async{
                                  bool result = await DataConnectionChecker().hasConnection;
                                  try {
                                    if(result == true) {
                                      showDialog(context: context, builder: (BuildContext context){
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          title: Text('Warning',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                                          content: Text('Do you really want to delete ad?',style: TextStyle(color: Colors.black)),
                                          actions: [
                                            TextButton(onPressed: ()async{
                                              await collectionads.doc(ads.id).delete();
                                              Navigator.of(context).pop();
                                              final snackbar = SnackBar(content: Text('Ad deleted'));
                                              ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                            }, child: Text('Yes',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold))),
                                            TextButton(onPressed: (){
                                              Navigator.of(context).pop();
                                            }, child: Text('No',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)) )
                                          ],
                                        );

                                      });
                                    } else {
                                      final snackbarerror = SnackBar(
                                          content: Text('Internet connection is lost'));
                                      ScaffoldMessenger.of(context).showSnackBar(snackbarerror);
                                    }
                                  } on Exception catch (e) {
                                    print(e);
                                  }

                                } : null,

                            ) : null,
                            userad == user?.uid || userad == googleUser?.id? ElevatedButton(
                              child: Text('Изменить'),
                                onPressed: userad == user?.uid || userad ==  googleUser?.id  ?(){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)
                                  => EditAdd((ads.data() as dynamic)['title'],
                                      (ads.data() as dynamic)['price'],
                                      (ads.data() as dynamic)['phone'],
                                      (ads.data() as dynamic)['desc'],ads,(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['url2'],(ads.data() as dynamic)['url3'],null,null,null,(ads.data() as dynamic)['city'],(ads.data() as dynamic)['currency'],(ads.data() as dynamic)['category'])));
                                } : null
                            ) :  ElevatedButton(

                              onPressed: (){

                                String ref = ads.reference.id;
                                if (favuid != null) {
                                  setState(() {
                                    if ((ads.data() as dynamic)['isfav$favuid'] == null || !(ads.data() as dynamic)['isfav$favuid']) {
                                      collectionads.doc(ref).update({
                                        'isfav$favuid': true

                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text("Add to Favourite list"),
                                      ));
                                    }
                                    else {
                                      collectionads.doc(ref).update({
                                        'isfav$favuid': false
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Text(
                                            "Deleted from Favourite list"),
                                      ));

                                    }
                                  });
                                  setState(() {
                                    !(ads.data() as dynamic)['isfav$favuid'] == (ads.data() as dynamic)['isfav$favuid'];
                                  });
                                }
                              },

                              child: Text((ads.data() as dynamic)['isfav$favuid'] == null || !(ads.data() as dynamic)['isfav$favuid']? 'Unfavourite' : 'Favourite',style:
                              TextStyle( color: (ads.data() as dynamic)['isfav$favuid'] == null || !(ads.data() as dynamic)['isfav$favuid']? Colors.green : Colors.white)),
                              style: ElevatedButton.styleFrom(
                                primary: (ads.data() as dynamic)['isfav$favuid'] == null || !(ads.data() as dynamic)['isfav$favuid']? Colors.white : Colors.black12,
                              ),

                            ),Icon(
                              Icons.remove_red_eye,color: MyColors.navy[100],
                            ),Text((ads.data() as dynamic)['viewcount'] != null?(ads.data() as dynamic)['viewcount'].toString() : '0',style: TextStyle(color: Colors.white,fontSize: 15),)

                        ),
                      );

                    });
              }
          )
      ),
    );
  }
}