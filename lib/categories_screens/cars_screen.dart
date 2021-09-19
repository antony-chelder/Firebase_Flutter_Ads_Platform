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


class CarsScreen extends StatefulWidget {
  static const id = 'cars_id';

  @override
  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  var countview = 0;

  CollectionReference myads = FirebaseFirestore.instance.collection('ads');
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    final cars = myads.where('category', isEqualTo: 'Cars').orderBy('time',descending: true).snapshots();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cars'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: cars,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot ads = snapshot.data!.docs[index];
                    String? favuid = user != null
                        ? user?.uid
                        : googleUser?.id;
                    final userad = (ads.data()as dynamic)['userid'];
                    return InkWell(
                      onTap: () {
                        if(user?.uid != userad){
                          setState(() {
                            countview = (ads.data()as dynamic)['viewcount'] +1 ;
                          });
                          String ref = ads.reference.id;
                          myads.doc(ref).update({
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
                      child: Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['desc'],(ads.data() as dynamic)['location'],
                          userad == user?.uid || userad == googleUser?.id?ElevatedButton(
                             child: Text('Удалить'),
                              onPressed: userad == user?.uid || userad == googleUser?.id?() async{
                                bool result = await DataConnectionChecker().hasConnection;
                                try {
                                  if(result == true) {
                                    showDialog(context: context, builder: (BuildContext context){
                                      return AlertDialog(
                                        title: Text('Warning'),
                                        content: Text('Do you really want to delete ad?'),
                                        actions: [
                                          TextButton(onPressed: ()async{
                                            await myads.doc(ads.id).delete();
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

                          ) :  null,
                          userad == user?.uid || userad == googleUser?.id? ElevatedButton(
                              child: Text('Изменить') ,
                              onPressed: userad == user?.uid || userad ==  googleUser?.id  ?(){
                                Navigator.of(context).push(MaterialPageRoute(builder: (context)
                                => EditAdd((ads.data() as dynamic)['title'],
                                    (ads.data() as dynamic)['price'],
                                    (ads.data() as dynamic)['phone'],
                                    (ads.data() as dynamic)['desc'],ads,(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['url2'],(ads.data() as dynamic)['url3'],null,null,null,(ads.data() as dynamic)['city'],(ads.data() as dynamic)['currency'],(ads.data() as dynamic)['category'])));
                              } : null
                          ) : ElevatedButton(

                          onPressed: () {

                      String ref = ads.reference.id;
                      String? favuidcars = user != null
                      ? user?.uid
                          : googleUser?.id;
                      if (favuidcars != null) {
                      setState(() {
                      if ((ads.data() as dynamic)['isfav$favuidcars'] == null || !(ads.data() as dynamic)['isfav$favuidcars']) {
                      myads.doc(ref).update({
                      'isfav$favuidcars': true

                      });
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text("Add to Favourite list"),
                      ));
                      }
                      else {
                      myads.doc(ref).update({
                      'isfav$favuidcars': false
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
                      !(ads.data() as dynamic)['isfav$favuidcars'] == (ads.data() as dynamic)['isfav$favuidcars'];
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
          },

        ),
      ),
    );
  }
}
