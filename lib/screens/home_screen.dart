import 'package:ads_platform/screens/favourite_screen.dart';
import 'package:ads_platform/screens/home_view.dart';
import 'package:ads_platform/screens/my_ads_screen.dart';
import 'package:ads_platform/screens/new_ad_screen.dart';
import 'package:ads_platform/screens/sign_in_screen.dart';
import 'package:ads_platform/screens/sign_up_screen.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  static const id = 'home_page_id';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0;
  int noUserIndex = 0;
  List<Widget> noUserPageList = <Widget>[
    HomeView(),
    SignIn(),
    SignUp()
  ];
  List<Widget> pageList = <Widget>[
    HomeView(),
    MyAds(),
    NewAd(null,null,null),
    FavouriteAds()
  ];
  final user = FirebaseAuth.instance.currentUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    if (user != null || googleUser != null) {
      if (pageIndex != 2) {
        return WillPopScope(
          onWillPop: () async => false,
          child:
          Scaffold(
            body: PageTransitionSwitcher(
                transitionBuilder: (child, primaryanimations,
                    secondaryanimations) =>
                    FadeThroughTransition(animation: primaryanimations,
                        secondaryAnimation: secondaryanimations,
                        child: child),
                child: pageList[pageIndex]
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.purpleAccent[400],
              selectedIconTheme: IconThemeData(color: Colors.purple),
              selectedItemColor: Colors.white70,
              unselectedItemColor: Colors.white70,
              unselectedIconTheme: IconThemeData(color: Colors.white),
              type: BottomNavigationBarType.fixed,
              currentIndex: pageIndex,
              onTap: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.supervised_user_circle), label: 'My ads'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add_box_rounded), label: 'Create ad'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite_outlined), label: 'Favourites'),
              ],
            ),
          )
          ,
        );
      } else {
        return Scaffold(
          body: NewAd(null,null,null
          ),
        );
      }
    } else {
      if (noUserIndex != 1 || noUserIndex != 2) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: noUserPageList[noUserIndex],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.purpleAccent[400],
              selectedIconTheme: IconThemeData(color: Colors.purple),
              selectedItemColor: Colors.white70,
              unselectedItemColor: Colors.white70,
              unselectedIconTheme: IconThemeData(color: Colors.white),
              type: BottomNavigationBarType.fixed,
              currentIndex: noUserIndex,
              onTap: (value) {
                setState(() {
                  noUserIndex = value;
                });
              },

              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_box), label: 'Sign In'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_outlined), label: 'Sign Up'),
              ],

            ),
          ),
        );
      } else {
        return Scaffold(
          body: noUserIndex == 1 ? SignIn() : SignUp(),
        );
      }
    }
  }
}
