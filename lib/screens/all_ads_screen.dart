import 'package:ads_platform/main.dart';
import 'package:ads_platform/screens/edit_screen.dart';
import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/screens/show_ad_screen.dart';
import 'package:ads_platform/ui/add_item_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';



class AllAds extends StatefulWidget {
  static const id ='all_ads_screen';

  @override
  _AllAdsState createState() => _AllAdsState();
}


class _AllAdsState extends State<AllAds> {
  CollectionReference collectionads = FirebaseFirestore.instance.collection('ads');
  final Stream<QuerySnapshot> adsStream = FirebaseFirestore.instance.collection('ads').orderBy('time',descending: true).snapshots();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:()async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.backspace_rounded),
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
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                        ShowAdScreen((ads.data() as dynamic)['title'],
                            (ads.data() as dynamic)['price'],
                            (ads.data() as dynamic)['phone'],
                            (ads.data() as dynamic)['desc'],(ads.data() as dynamic)['category'])
                    )),
                    child: Ads((ads.data() as dynamic)['title'], (ads.data() as dynamic)['price'],(ads.data() as dynamic)['url1'],
                        userad == user?.uid || userad ==  googleUser?.id  ?  IconButton(
                            onPressed: userad == user?.uid || userad ==  googleUser?.id  ?() async{
                              bool result = await DataConnectionChecker().hasConnection;
                              try {
                                if(result == true) {
                                  showDialog(context: context, builder: (BuildContext context){
                                    return AlertDialog(
                                      title: Text('Warning'),
                                      content: Text('Do you really want to delete ad?'),
                                      actions: [
                                        TextButton(onPressed: ()async{
                                          await collectionads.doc(ads.id).delete();
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
                            icon: userad == user?.uid || userad == googleUser?.id ? Icon(Icons.delete) : Icon(null)

                        ) : null,
                        userad == user?.uid || userad == googleUser?.id? IconButton(
                            icon: userad == user?.uid || userad == googleUser?.id?Icon(Icons.edit) : Icon(null) ,
                            onPressed:(){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)
                              => EditAdd((ads.data() as dynamic)['title'],
                                  (ads.data() as dynamic)['price'],
                                  (ads.data() as dynamic)['phone'],
                                  (ads.data() as dynamic)['desc'],ads,(ads.data() as dynamic)['url1'],(ads.data() as dynamic)['url2'],(ads.data() as dynamic)['url3'],null,null,null)));
                            }
                        ) : null

                         ),
                  );

                });
          }
        )
        ),
    );
  }
}
