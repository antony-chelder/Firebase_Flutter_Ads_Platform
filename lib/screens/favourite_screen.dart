import 'package:flutter/material.dart';
class FavouriteAds extends StatefulWidget {
  const FavouriteAds({Key? key}) : super(key: key);

  @override
  _FavouriteAdsState createState() => _FavouriteAdsState();
}

class _FavouriteAdsState extends State<FavouriteAds> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Favourite ads'),
        centerTitle: true,
      ),
    );
  }
}
