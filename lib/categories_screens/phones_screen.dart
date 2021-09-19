import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/ui/add_item_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PhonesScreen extends StatefulWidget {
  static const id = 'phones_id';

  @override
  _PhonesScreenState createState() => _PhonesScreenState();
}

class _PhonesScreenState extends State<PhonesScreen> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference myads = FirebaseFirestore.instance.collection('ads');
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    final phones = myads.where('category', isEqualTo: 'Smartphones').orderBy('time',descending: true).snapshots();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Phones'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.backspace_rounded),
            onPressed: (){
              Navigator.pushNamed(context, HomePage.id);
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: phones,
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
                  return Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['desc'],
                      (ads.data() as dynamic)['location'],
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

                      ) : null,
                      ElevatedButton(
                          child: Text('Редактировать'),
                          onPressed:(){
                            print('Click');
                          }
                      ),null,null
                  );

                });

          },

        ),
      ),
    );
  }
}
