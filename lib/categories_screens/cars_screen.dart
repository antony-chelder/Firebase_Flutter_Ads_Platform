import 'package:ads_platform/screens/edit_screen.dart';
import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/ui/add_item_ui.dart';
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
  CollectionReference myads = FirebaseFirestore.instance.collection('ads');
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
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
            icon: Icon(Icons.backspace_rounded),
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
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text('Loading...'),
              );
            }
            return Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                    DocumentSnapshot ads = snapshot.data!.docs[index];
                    final userad = (ads.data()as dynamic)['userid'];
                    return Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],
                        userad == user?.uid || userad == googleUser?.id?IconButton(
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
                                        }, child: Text('Yes')),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();
                                        }, child: Text('No') )
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
                            icon: userad == user?.uid || userad == googleUser?.id?Icon(Icons.delete) : Icon(null)

                        ) : null,
                        IconButton(
                            icon: userad == user?.uid || userad == googleUser?.id?Icon(Icons.edit) : Icon(null) ,
                            onPressed:(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)
                              => EditAdd((ads.data() as dynamic)['title'],
                                  (ads.data() as dynamic)['price'],
                                  (ads.data() as dynamic)['phone'],
                                  (ads.data() as dynamic)['desc'],ads,(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['url2'],(ads.data() as dynamic)['url3'],null,null,null)));
                            }
                        )
                    );

                  }),
            );

          },

        ),
      ),
    );
  }
}
