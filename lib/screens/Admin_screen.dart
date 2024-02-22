

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:web_admin/screens/login_screen.dart';




class AdminScreen extends StatefulWidget {
  static const String id ="Admin-Screen";

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formkey =GlobalKey<FormState>();

  bool _isObscure3 = true;

  bool visible = false;


  TextEditingController nameCon = TextEditingController();
  TextEditingController phoneCon = TextEditingController();
  var emailCNTL = TextEditingController();
  var passCNTL = TextEditingController();

  FirebaseServices _services = FirebaseServices();
  final _auth = FirebaseAuth.instance;

  var oldpassCNTL = TextEditingController();
  var newpassword =" " ;
  final newpassCNTL = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose(){
    newpassCNTL.dispose();
    super.dispose();
  }
  changePassword()async {
    try{
      await
        currentUser!.updatePassword(newpassword).then((value) {
        EasyLoading.showSuccess('Password changed');
        EasyLoading.dismiss();
        clean();
      });







      }catch(error) {

    }
  }
  createAdmin({email,password})async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }on FirebaseAuthException catch(e){
      print(e.toString());
    }
  }
  clean(){
    setState(() {
      passCNTL.clear();
      emailCNTL.clear();
      nameCon.clear();
      phoneCon.clear();
      newpassCNTL.clear();

    });
  }
  saveAdminTofirebase()async {
    _services.SaveCategory(
      data: {
        'uid':_services.users.doc().id,
        'email': emailCNTL.text,
        'name':nameCon.text,
        'phone':phoneCon.text,
        'role':"Admin",

      },
      reference: _services.users,

    ).then((value) {
      EasyLoading.showSuccess('Admin Created');
      EasyLoading.dismiss();
      clean();
    });
  }


  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(10.0),
    child:Column(
    children: [


          Center(child: Text("Admin",style: TextStyle(color: Colors.green, fontSize: 30),)),
          SizedBox(width: 10),

          SizedBox(width: 15),
          /*IconButton(onPressed: (){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => Dialog(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
            child: ListView(
            shrinkWrap: true,
            children: <Widget>[
            Form(
            key:_formkey,
            child:Padding(
            padding: const EdgeInsets.all(20.0),
            child:Center(
            child: Container(
            width: MediaQuery.of(context).size.width * .5,
            child: Column(
            children: [
              Text("Add New Admin",style: TextStyle(color: Colors.greenAccent,fontSize: 15,fontWeight: FontWeight.bold),),

            const SizedBox(height: 20),
            TextFormField(
            controller:nameCon,
            decoration: InputDecoration(
            label:  Text("Full Name",style: TextStyle(color: Colors.greenAccent),),
            prefixIcon: Icon(Icons.person,color: Colors.greenAccent,),
            filled: true,
            fillColor: Colors.white,
            hintText: 'admin name',
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
            else {
            return null;
            }
            },
            onSaved: (value) {
            nameCon.text = value!;
            },
            keyboardType: TextInputType.name,
            ),
            SizedBox(
            height: 20,
            ),

            TextFormField(
            controller:phoneCon,
            decoration: InputDecoration(
            label: Text("Phone",style: TextStyle(color: Colors.greenAccent),),
            prefixIcon: Icon(Icons.phone,color: Colors.greenAccent,),

            filled: true,
            fillColor: Colors.white,
            enabled: true,
            contentPadding: const EdgeInsets.only(
            left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.greenAccent,width: 4),
            borderRadius: new BorderRadius.circular(10),
            ),
            hintText: "+249 123456789",
            enabledBorder: UnderlineInputBorder(
            borderSide: new BorderSide(color: Colors.white),
            borderRadius: new BorderRadius.circular(10),
            ),
            ),
            validator: (value) {
            RegExp regex = new RegExp(r'^.{10,}$');
            if (value!.isEmpty) {
            return "Phone cannot be empty";
            }
            if (!regex.hasMatch(value)) {
            return ("please enter valid Phone Number min. 10 Numbers");
            } else {
            return null;
            }
            },
            onSaved: (value) {
            phoneCon.text = value!;
            },
            keyboardType: TextInputType.number,
            ),
            SizedBox(
            height: 20,
            ),

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
            Row(
            children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
            onPressed: () {

            setState(() {
            visible = true;
            });
            Navigator.pop(context);



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
            'Cancel',
            style: TextStyle(
            color: Colors.white,
            letterSpacing: 2,
            fontSize: 16,
            ),
            )
            ),
            ),
            SizedBox(width:3),
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
            onPressed: () async{

            setState(() {
            visible = true;
            });
            if (_formkey.currentState!.validate()) {
            await createAdmin(email: emailCNTL.text,
            password: passCNTL.text);
            EasyLoading.show(status: 'Saving..');
            saveAdminTofirebase();
            Navigator.pop(context);

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
            'Sign Up',
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




            ],
            ),
            ),
            )
            ),
            ),
            ],
            ),
                ),
                ));
          }, icon: Icon(Icons.person_add)),*/

      const SizedBox(height: 20),
      Container(height: 60,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 100,
              child: Text('ID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),

            Container(
              width: 100,
              child: Text('Name',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),

            Container(
              width: 100,
              child: Text('Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),
            Container(
              width: 100,
              child: Text('Phone',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),

          ],
        ),
      ),
      const SizedBox(height: 5),
      Container(
        height: 600,

        child:
        StreamBuilder<QuerySnapshot>(
            stream: _services.users.where('role',isEqualTo: 'Admin').snapshots(),
            builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    if (!snapshot.hasData) {
    return Text("No Data");
    }
    if (snapshot.hasError) {
    return Text("Error");
    }
    if (snapshot == null) {
    return Text("Error");
    }
    if (snapshot.data!.size == 0) {
      return Center(
        child: Text("No Data"),
      );
    }
              if(snapshot.connectionState ==ConnectionState.waiting){
                return  Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
              if(snapshot.hasData){
                return
                  ListView.builder(

                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context ,index) =>

                        Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 120,
                                    child: Text(snapshot.data!.docs[index]['uid']),
                                  ),

                                  Container(
                                    width: 120,
                                    child: Text(snapshot.data!.docs[index]['name']),
                                  ),

                                  Container(
                                    width: 120,
                                    child: Text("${snapshot.data!.docs[index]['email']}"),
                                  ),
                                  Container(
                                    width: 120,
                                    child: Text("${snapshot.data!.docs[index]['phone']}"),
                                  ),





                                ]),
                            Divider(thickness: 3,color:Colors.grey),
                          ],
                        ),

                  );

              } return  Center(
                child: CircularProgressIndicator(
                  color: Colors.greenAccent,
                ),
              );
            }
        ),
      ),

    ]
    ),
    );
  }
}
