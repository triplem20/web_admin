import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/services/firebase_services.dart';




class UsersScreen extends StatefulWidget {
  static const String id ="Users-Screen";

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  FirebaseServices _services = FirebaseServices();



  @override
  Widget build(BuildContext context) {



    return  Padding(
      padding: const EdgeInsets.all(10.0),
      child:Column(
        children: [
          Text("Customer Details",style: TextStyle(color: Colors.green, fontSize: 30),),
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
                  child: Text('Phone',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),

                Container(
                  width: 100,
                  child: Text('Email',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Address',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 600,

            child:
            StreamBuilder<QuerySnapshot>(
                stream: _services.users.where('role',isEqualTo: "user").snapshots(),
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
        child: Text("No Users"),
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
                                        child: Text(snapshot.data!.docs[index]['uid'] ),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text(snapshot.data!.docs[index]['name']),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text(snapshot.data!.docs[index]['phone']),
                                      ),

                                      Container(
                                        width: 120,
                                        child: Text("${snapshot.data!.docs[index]['email']}"),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text(snapshot.data!.docs[index]['address']),
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



        ],
      ),
    );

  }

  _showAlertDialog(context,title, message,id)async {
    showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Center(child: Text(title),),
          content: Container(width: 10,

              decoration: BoxDecoration(
                  color:Color.fromARGB(255, 252, 118, 105),
                borderRadius: BorderRadius.circular(3),
              ),child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(message,style: TextStyle(color: Color.fromARGB(
                200, 86, 0, 0),fontWeight: FontWeight.bold),),
          )),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Cancel")),
            TextButton(onPressed: (){



            }, child: Text("Delete")),


          ],
        )
    );
  }
}
