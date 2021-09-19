import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/screens/sign_up_screen.dart';
import 'package:ads_platform/ui/button_decoration.dart';
import 'package:ads_platform/ui/colors.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:ads_platform/ui/text_button_decoration.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
    static const id = 'sign_in_id';

    @override
    _SignInState createState() => _SignInState();
    }
    class _SignInState extends State<SignIn> {
    final textemaIlcontroller = TextEditingController();
    final textpasswordcontroller = TextEditingController();
    final textnamecontroller = TextEditingController();
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    final _auth = FirebaseAuth.instance;
    String errormessage = '';
    bool showpreogress = false;
    @override
    Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
    backgroundColor: MyColors.navy[200],
    body: ModalProgressHUD(
    inAsyncCall: showpreogress,
    child: Padding(
    padding: const EdgeInsets.only(left: 16, right: 16),
    child: Form(
    key: _formkey,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('Buy me',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold, color: Colors.white),),
    SizedBox(height: 12.0,),

    TextFormField(
    keyboardType: TextInputType.emailAddress,
    validator: validatoremail,
    decoration: textfielddecoration,
    controller: textemaIlcontroller,
    ),

    SizedBox(height: 12.0,),
    TextFormField(
    validator: validatorpassword,
    obscureText: true,
    decoration: textfielddecoration.copyWith(prefixIcon: Icon(Icons.lock,color: MyColors.navy[50],), hintText: 'Enter password'),
    controller: textpasswordcontroller,
    ),
    SizedBox(height: 7.0,),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.max,
    children: [
    Flexible(
    child: Text(errormessage,style: TextStyle(fontSize: 12,color: Colors.lightGreenAccent[100])),
    ),
    ],
    ),
    SizedBox(height: 16.0,),
    Buttons(MyColors.navy, 'Sign In',() async {
    bool result = await DataConnectionChecker().hasConnection;
    final snackbarerror = SnackBar(
    content: Text('Internet connection is lost'));
    setState(() {
    showpreogress = true;
    });
    try {
    if(_formkey.currentState!.validate()) {
    if(result == true) {
    final signeduser = await _auth
        .signInWithEmailAndPassword(
    email: textemaIlcontroller.text,
    password: textpasswordcontroller.text);
    errormessage = '';
    if (signeduser != null) {
    Navigator.pushNamed(context, HomePage.id);
    textpasswordcontroller.clear();
    }
    } else {
    ScaffoldMessenger.of(context).showSnackBar(snackbarerror);
    }
    }
    } on FirebaseAuthException catch (e) {
    errormessage = e.message!;
    }
    Future.delayed(Duration(seconds: 3), (){
    setState(() {
    showpreogress = !showpreogress;
    });
    });
    },TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
    SizedBox(height: 12.0,),
    Buttons(Colors.white, 'G', () async {
    setState(() {
    showpreogress = true;
    });
    try {
    final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);
    Navigator.pushNamed(context, HomePage.id);

    } on FirebaseAuthException catch (e) {
    print(e.message);
    rethrow;
    }

    setState(() {
    showpreogress = false;
    });
    }, TextStyle(color: Colors.red,fontSize: 24.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12.0,),
                  Buttons(Colors.white, 'Sign Up', () {
                    Navigator.pushNamed(context, SignUp.id);
                    textpasswordcontroller.clear();
                  }, TextStyle(color: MyColors.navy[200], fontSize: 24.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 30.0,),
                  TextButtons('Register later', () {
                    Navigator.pushNamed(context, HomePage.id);
                  }, TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold,decoration: TextDecoration.underline)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? validatoremail(String? formvalidator){
  if(formvalidator!.isEmpty) {
    return 'Email field is required';
  }
    String patternEmail =  r'\w+@\w+\.\w+';
    RegExp regExp = RegExp(patternEmail);

    if(!regExp.hasMatch(formvalidator)) return 'Invalid E-mail Address format';

    return null;

}

String? validatorpassword(String? formvalidator){
  if(formvalidator!.isEmpty){
    return 'Password field is required';
  }
  String patternPassword = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regExp = RegExp(patternPassword);

  if(!regExp.hasMatch(formvalidator)) return 'Password must be at least 8 characters,include upper case letter,number,symbol';

  return null;

}
