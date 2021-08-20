import 'package:ads_platform/categories_screens/cars_screen.dart';
import 'package:ads_platform/categories_screens/closes_screen.dart';
import 'package:ads_platform/categories_screens/pc_screen.dart';
import 'package:ads_platform/categories_screens/phones_screen.dart';
import 'package:ads_platform/screens/all_ads_screen.dart';
import 'package:ads_platform/screens/sign_in_screen.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomeView extends StatefulWidget {
  static const id = 'homeviewconst';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        actions: [
          IconButton(onPressed:(user!= null || googleUser!=null)? ()async {
            if(googleUser == null) {
              await _auth.signOut();
              Navigator.pushNamed(context, SignIn.id);
            } else {
              await _googleSignIn.signOut();
              Navigator.pop(context);
            }
          } : null, icon:  (user!= null || googleUser!=null) ?  Icon(Icons.exit_to_app) : Icon(null))
        ],
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: 16),
        children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  child: Ink(
                    decoration: boxdecoration,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, AllAds.id);
                      },
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('All Ads',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                        ),

                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(right: 30.0)),
                Material(
                  child: Ink(
                    decoration: boxdecoration,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, CarsScreen.id);
                      },
                      child: Container(
                        height: 100.0,
                        width: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text('Cars',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                          ),
                        ),

                      ),
                    ),
                  ),
                ),
              ],
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, ClosesScreen.id);
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Closes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 30.0)),
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, PhonesScreen.id);
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Phones',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, PcScreen.id);
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('PC',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                        ),
                      ),

                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 30.0)),
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      print('Hello');
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,

                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      print('Hello');
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,

                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(right: 30.0)),
              Material(
                child: Ink(
                  decoration: boxdecoration,
                  child: InkWell(
                    onTap: (){
                      print('Hello');
                    },
                    child: Container(
                      height: 100.0,
                      width: 100.0,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
