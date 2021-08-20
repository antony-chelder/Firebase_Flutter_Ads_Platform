import 'package:ads_platform/ui/add_item_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyAds extends StatefulWidget {
  static const id = "my_ads";

  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference myads = FirebaseFirestore.instance.collection('ads');
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);


  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    final resultmyads = myads.where('userid', isEqualTo: user!= null ? user!.uid : googleUser!.id).snapshots();
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text('My Ads'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: resultmyads,
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
                            print('Click');
                          }
                        )
                 );

              });

        },

      ),
    );

  }
}
