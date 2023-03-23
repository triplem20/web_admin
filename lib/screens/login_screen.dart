import 'package:flutter/material.dart';

import 'home_screen.dart';



class LoginScreen extends StatelessWidget {
  static const String id ="Login-screen";
 final _forekey =GlobalKey<FormState>();
  String adminEmail = " ";
  String adminPassword = " ";
  var emailCNTL = TextEditingController(text:"admin@gmail.com");
  var passCNTL = TextEditingController(text:"123456");

  @override
  Widget build(BuildContext context) {
      return Form(
        key:_forekey,
        child:Scaffold(
          backgroundColor: Colors.black,
          body:Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .5,
              child: Column(
                children: [
                  const SizedBox(height: 65),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/splash.png')),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 20),

                     Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onChanged: (value) {
                          adminEmail = value;

                        },
                        obscureText: false,
                        controller: emailCNTL,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty) {
                            return "Enter Your Email Address ";
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.greenAccent,
                                  width: 2,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 2,
                                )),
                            hintText: "Email",

                            hintStyle: TextStyle(color: Colors.grey),
                            icon: Icon(
                              Icons.email,
                              color: Colors.greenAccent,
                            )),
                      ),
                    ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {

                        adminPassword =value;

                      },
                      obscureText: true,
                      controller: passCNTL,
                      validator: (value){
                        if(value!.isEmpty) {
                          return "Enter Your Password ";
                        }
                        return null;
                      },

                      style: const TextStyle(fontSize: 16, color: Colors.white),

                      decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                                width: 2,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.pinkAccent,
                                width: 2,
                              )),
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.grey),
                          icon: Icon(
                            Icons.admin_panel_settings,
                            color: Colors.greenAccent,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          if(_forekey.currentState!.validate()){
                            Navigator.pushNamed(context, HomeScreen.id);
                          }


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
                        )),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
