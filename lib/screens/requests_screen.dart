

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/services/firebase_services.dart';


class RequestsScreen extends StatelessWidget {
  static const String id ="Requests-Screen";
  FirebaseServices _services = FirebaseServices();

  TextEditingController statusController =TextEditingController();


  @override
  Widget build(BuildContext context) {



    return  Padding(
        padding: const EdgeInsets.all(10.0),
        child:Column(
        children: [
          Text("Requests",style: TextStyle(color: Colors.green, fontSize: 30),),
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
                child: Text('Request ID'),
              ),
              Container(
                width: 100,
                child: Text('Category'),
              ),
              Container(
                width: 100,
                child: Text('Name'),
              ),

              Container(
                width: 100,
                child: Text('Price'),
              ),
              Container(
                width: 100,
                child: Text('Status'),
              ),

              Container(
                width: 100,
                child: Text('Date'),
              ),
              Container(
                width: 100,
                child: Text('              '),
              ),
            ],
          ),
        ),
          const SizedBox(height: 5),
          Container(
        height: 600,

        child:
        StreamBuilder<QuerySnapshot>(
        stream: _services.Requests.snapshots(),
        builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return Text("Error");
          }
          if(snapshot.connectionState ==ConnectionState.waiting){
            return  Center(
              child: CircularProgressIndicator(
                color: Colors.greenAccent,
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
                                          child: Text(snapshot.data!.docs[index]['id']),
                                        ),
                                          Container(
                                            width: 120,
                                            child: Text(snapshot.data!.docs[index]['category']),
                                          ),
                                          Container(
                                            width: 120,
                                            child: Text(snapshot.data!.docs[index]['title']),
                                          ),

                                          Container(
                                            width: 120,
                                            child: Text("${snapshot.data!.docs[index]['price']}"),
                                          ),
                                          Container(
                                            width: 120,
                                            child: Text(snapshot.data!.docs[index]['request status']),
                                          ),

                                          Container(
                                            width: 120,
                                            child: Text(snapshot.data!.docs[index]['date']),
                                          ),





                                  Container(
                                    child:
                                    snapshot.data!.docs[index]['request status']== 'Accepted'?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                        width: 120,
                                        child:Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text("Order Accepted",style: TextStyle(color:Colors.black),),
                                        )
                                    ) :Row(
                                      children: [
                                        TextButton(onPressed: () {
                                            showCupertinoDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: Center(
                                                    child: Text("Accept Request",),),
                                                  content: Text("Are You Sure?",),
                                                  actions: [
                                                    TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
                                                        onPressed: (){
                                                      Navigator.of(context).pop();

                                                    }, child: Text("Cancel",
                                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
                                                    TextButton(
                                                    style: ButtonStyle(
                                                    backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),onPressed: (){
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                          .reference
                                                          .update({

                                                        'request status': "Accepted",


                                                      })
                                                          .then((
                                                          value) {
                                                        Navigator
                                                            .of(
                                                            context)
                                                            .pop();
                                                        EasyLoading
                                                            .showSuccess(
                                                            "Request Accepted");
                                                      });



                                                    },
                                                        child: Text("Ok",style: TextStyle(color:Colors.white),)),
                                                  ],
                                                )
                                            );
                                  },
                                          child: Text("Accept",
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.green),
                                          ),),
                                        SizedBox(width: 6),
                                        AbsorbPointer(
                                          absorbing:  snapshot.data!.docs[index]['request status']== 'Rejected'
                                              ?true
                                          :false,
                                          child: TextButton(onPressed: (){
                                            showCupertinoDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (BuildContext context) => AlertDialog(
                                                  title: Center(
                                                    child: Text("Reject Request"),),
                                                  content:Text("Are You Sure?"),
                                                  actions: [
                                                    TextButton(
                                                style: ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
                                                        onPressed: (){
                                                      Navigator.of(context).pop();

                                                    }, child: Text("Cancel", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
                                                    TextButton(
                                                        style: ButtonStyle(
                                                          backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
                                                        onPressed: (){
                                                      snapshot
                                                          .data!
                                                          .docs[index]
                                                          .reference
                                                          .update({

                                                        'request status': "Rejected",


                                                      })
                                                          .then((
                                                          value) {
                                                        Navigator
                                                            .of(
                                                            context)
                                                            .pop();
                                                        EasyLoading
                                                            .showSuccess(
                                                            "Request Rejected");
                                                      });
                                                    },
                                                        child: Text("Ok",  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))),
                                                  ],
                                                )
                                            );



                                          }, child: Text("Reject",
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStatePropertyAll( snapshot.data!.docs[index]['request status']== 'Rejected'
                                                    ?Colors.grey :Colors.red),)),
                                        ),
                                      ],
                                    ),

                                  ) ,
              ]),
                              Divider(thickness: 3,color:Colors.grey),
                            ],
                          ),

                  );

          } return  Center(
            child: CircularProgressIndicator(
              color:Colors.greenAccent,
            ),
          );
        }
    ),
    ),

      ],
    ),
        );

  }

}
