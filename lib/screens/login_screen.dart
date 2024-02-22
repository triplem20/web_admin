import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'home_screen.dart';



class LoginScreen extends StatefulWidget {
  static const String id ="Login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 final _formkey =GlobalKey<FormState>();

  bool _isObscure3 = true;

  bool visible = false;


  var emailCNTL = TextEditingController();

  var passCNTL = TextEditingController();

  final _auth = FirebaseAuth.instance;
  


  @override
  Widget build(BuildContext context) {
      return Form(
        key:_formkey,
        child:Scaffold(
          backgroundColor: Colors.black,
          body:Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5,color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(image:NetworkImage('assets/images/admin2.png'),),

                    ),
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller:emailCNTL,
                    decoration: InputDecoration(
                      label:  Text("Email Address",style: TextStyle(color: Colors.greenAccent),),
                      prefixIcon: Icon(Icons.email,color: Colors.greenAccent,),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'admin@gmail.com',
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.greenAccent,width: 4),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value!.length == 0) {
                        return "Email cannot be empty";
                      }
                      if (!RegExp(
                          "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return ("Please enter a valid email");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      emailCNTL.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passCNTL,
                    obscureText: _isObscure3,
                    decoration: InputDecoration(
                     label: Text("Password",style: TextStyle(color: Colors.greenAccent),),
                      prefixIcon: Icon(Icons.lock,color: Colors.greenAccent,),
                      suffixIcon: IconButton(
                          icon: Icon(_isObscure3
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure3 = !_isObscure3;
                            });
                          }),
                      filled: true,
                      fillColor: Colors.white,
                      enabled: true,
                      contentPadding: const EdgeInsets.only(
                          left: 14.0, bottom: 8.0, top: 8.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.greenAccent,width: 4),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      hintText: "*********",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.white),
                        borderRadius: new BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      RegExp regex = new RegExp(r'^.{6,}$');
                      if (value!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (!regex.hasMatch(value)) {
                        return ("please enter valid password min. 6 character");
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      passCNTL.text = value!;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {

    setState(() {
    visible = true;
    });
    signIn(
    emailCNTL.text, passCNTL.text);
    EasyLoading.instance
      ..displayDuration =const Duration(milliseconds: 2000)
      ..loadingStyle =EasyLoadingStyle.light;
    //This was missing in earlier code


EasyLoading.show(status: "Logging in");



                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.greenAccent),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.pinkAccent),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                        )
                    ),
                  ),

                ],
              ),
            ),
          )
      ),
    );
  }
 void route() {
   User? user = FirebaseAuth.instance.currentUser;
   var kk = FirebaseFirestore.instance
       .collection('users')
       .doc(user!.uid)
       .get()
       .then((DocumentSnapshot documentSnapshot) {
     if (emailCNTL.text == "mustafastudies123@gmail.com" && passCNTL.text == "mustafa123")  {


         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) =>  HomeScreen(),
           ),
         );
         EasyLoading.showToast('Welcome Admin !');
         EasyLoading.dismiss();


        } else {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor:Colors.red,content:Container(child:Text('Document does not exist on the database'),)));
       print('Document does not exist on the database');
     }
   });
 }
 void signIn(String email, String password) async {
   if (_formkey.currentState!.validate()) {
     try {
       UserCredential userCredential =
       await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: email,
         password: password,

       );
       route();
     } on FirebaseAuthException catch (e) {
       if (e.code == 'user-not-found') {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             backgroundColor: Colors.red,
             content: Container(
               child: Text('No user found for that email.'),)));
         print('No user found for that email.');
         EasyLoading.dismiss();
       } else if (e.code == 'wrong-password') {
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
             backgroundColor: Colors.red,
             content: Container(
               child: Text('Wrong password provided for that user.'),)));
         print('Wrong password provided for that user.');
         EasyLoading.dismiss();
       }
     }
   }
 }
}