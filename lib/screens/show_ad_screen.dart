import 'package:flutter/material.dart';

class ShowAdScreen extends StatefulWidget {
  String titletext;
  String pricetext;
  String phonetext;
  String desctext;
  String currentCat;


  ShowAdScreen(this.titletext, this.pricetext, this.phonetext, this.desctext,this.currentCat);

  @override
  _ShowAdScreenState createState() => _ShowAdScreenState();
}

class _ShowAdScreenState extends State<ShowAdScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String categoryCurrentItem = 'Cars';
  List<String> categoryList = <String>[
    'Cars',
    'Closes',
    'Smartphones',
    'PC'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.titletext),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
        child: SafeArea(
        child: Padding(
        padding: EdgeInsets.all(16.0),
    child: Form(
    key: _key,
    child: Column(
    children: [
    Container(
    color: Colors.redAccent,
    height: 150,
    width: 300,
    child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: PageView(
    pageSnapping: true,
    children: [
    Container(height: 40,width: 180, color: Colors.deepOrange,),
    Container(height: 40,width: 180, color: Colors.blue,),
    Container(height: 40,width: 180, color: Colors.yellow,)
    ],
    ),
    ),

    ),
    SizedBox(height: 20.0,),
    TextFormField(
      enabled: false,
    initialValue: widget.titletext,
    ),
    SizedBox(height: 8.0,),
    Padding(
    padding: const EdgeInsets.only(left: 4),
    child: Align(
    alignment: Alignment.centerLeft,
    child: DropdownButton(
    value: categoryCurrentItem,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 30,
    elevation: 15,
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    underline: Container(
    width: 150,
    height: 2,
    color: Colors.purple,
    ),
    onChanged: null,
    items: categoryList.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
    value: value,
    child: Text(widget.currentCat),
    )).toList()
    ),
    ),
    ),
    SizedBox(height: 8.0,),
    TextFormField(
      enabled: false,
    initialValue: widget.pricetext,
    ),
    SizedBox(height: 8.0,),

    TextFormField(
        enabled: false,
    initialValue: widget.phonetext,
    ),

    SizedBox(height: 10.0,),

    TextFormField(
      enabled: false,
    initialValue: widget.desctext,
    maxLines: 12,
    ),

    ],
    ),
    ),
    ),
    ),
    ));
  }
}
