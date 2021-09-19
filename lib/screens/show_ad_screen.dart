import 'package:ads_platform/screens/full_images_screen.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class ShowAdScreen extends StatefulWidget {
  String titletext;
  String pricetext;
  String phonetext;
  String location;
  String desctext;
  String currentCat;
  String url1;
  String url2;
  String url3;



  ShowAdScreen(this.titletext, this.pricetext, this.phonetext, this.desctext,this.currentCat,this.url1,this.url2,this.url3,this.location);

  @override
  _ShowAdScreenState createState() => _ShowAdScreenState();
}

class _ShowAdScreenState extends State<ShowAdScreen> {
  var _controller = ScrollController();
  bool ishide = false;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String categoryCurrentItem = 'Cars';
  List<String> categoryList = <String>[
    'Cars',
    'Closes',
    'Smartphones',
    'PC'
  ];
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
        if (_controller.position.pixels <= 209) {
          setState(() {
            ishide = false;
            print(_controller.position.pixels);
          });

        } else {
          setState(() {
            ishide = true;
            print(_controller.position.pixels);
          });
        }

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.titletext),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          controller: _controller,
        child: SafeArea(
        child: Padding(
        padding: EdgeInsets.all(16.0),
    child: Form(
    key: _key,
    child: Column(
    children: [
    InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => FullImage(widget.url1, widget.url2, widget.url3))),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color : Colors.green)
        ),
      height: 300,
      width: 550,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: PageView(
      pageSnapping: true,
      children: [
      Image.network(widget.url1),
      Image.network(widget.url2),
      Image.network(widget.url3)
      ],
      ),
      ),

      ),
    ),
    SizedBox(height: 20.0,),
        TextFormField(
          decoration: textshowad,
        enabled: false,
        initialValue: widget.titletext,
      ),

    SizedBox(height: 8.0,),
    Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Category:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
          ),
        ),
        SizedBox(width: 8.0,),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: textdef,
              initialValue: widget.currentCat,
              enabled: false,
            ),
          ),
        )

      ],
    ),
      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Price:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            ),
          ),
          SizedBox(width: 8.0,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: textdef,
                initialValue: widget.pricetext,
                enabled: false,
              ),
            ),
          )

        ],
      ),
    SizedBox(height: 8.0,),
      Row(
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Phone:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
          ),
          SizedBox(width: 54.0),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: textdef,
                initialValue: widget.phonetext,
                enabled: false,
              ),
            ),
          )

        ],
      ),
    SizedBox(height: 8.0,),
      Row(
        children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Location:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            ),
          SizedBox(width: 36.0,),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: textdef,
                initialValue: widget.location,
                enabled: false,
              ),
            ),
          )

        ],
      ),
      SizedBox(height: 15.0,),
    TextFormField(
      enabled: false,
    decoration: textshowad.copyWith(labelText: 'Description'),
    initialValue: widget.desctext,
    maxLines: 12,
    ),

    ],
    ),
    ),
    ),
    ),
    ),floatingActionButton: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
      Padding(
        padding: EdgeInsets.only(left: 32.0),
        child: Visibility(
          visible: !ishide? true : false,
          child: FloatingActionButton(
          heroTag: 'btn1',
          child: Icon(Icons.mail),
          onPressed: (){},
          ),
        ),
      ),
         Visibility(
           visible: !ishide? true : false,
           child: FloatingActionButton(
            heroTag: 'btn2',
            child: Icon(Icons.call),
            onPressed: (){
              UrlLauncher.launch(('tel://${widget.phonetext}'));
            },
        ),
         )

      ],
    )


    );
  }
}
