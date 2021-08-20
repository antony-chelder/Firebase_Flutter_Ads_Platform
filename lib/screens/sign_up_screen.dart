import 'package:ads_platform/screens/home_screen.dart';
import 'package:ads_platform/ui/button_decoration.dart';
import 'package:ads_platform/ui/constants_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  static const id = 'sign_up_id';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final textemaIlcontroller = TextEditingController();
  final textpasswordcontroller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String errormessage = '';
  bool showpreogress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showpreogress,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Buy me', style: TextStyle(fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple[400]),),
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
                    decoration: textfielddecoration.copyWith(
                        prefixIcon: Icon(Icons.lock), hintText: 'Enter password'),
                    controller: textpasswordcontroller,
                  ),
                  SizedBox(height: 7.0,),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                          child: Text(errormessage,style: TextStyle(fontSize: 12,color: Colors.red)),
                      ),
                    ],
                    ),

                SizedBox(height: 16.0,),
                Buttons(Colors.purple, 'Register', () async {
                  setState(() {
                    showpreogress = true;
                  });
                  try {
                    if(_formkey.currentState!.validate()) {
                      final signUpuser = await _auth
                          .createUserWithEmailAndPassword(
                          email: textemaIlcontroller.text,
                          password: textpasswordcontroller.text);
                      errormessage = '';
                      if (signUpuser != null) {
                        Navigator.pushNamed(context, HomePage.id);
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    errormessage = e.message!;
                  }
                  setState(() {
                    showpreogress = false;
                  });
                },TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
                Buttons(Colors.white, 'Back', () {
                  Navigator.pop(context);
                }, TextStyle(color: Colors.purple, fontSize: 16.0, fontWeight: FontWeight.bold))
              ],
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

