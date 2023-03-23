

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/services/firebase_services.dart';


class RequestsScreen extends StatelessWidget {
  static const String id ="Requests-Screen";
  FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {



    return  Padding(
        padding: const EdgeInsets.all(10.0),
        child:Column(
        children: [
          Text("Requests",style: TextStyle(color: Colors.blue, fontSize: 30),),
        const SizedBox(height: 15),

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
                child: Text('Service ID'),
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
                                            child: Text(snapshot.data!.docs[index]['productId']),
                                          ),
                                          Container(
                                            width: 120,
                                            child: Text(snapshot.data!.docs[index]['date']),
                                          ),



                                  Container(
                                    child: Row(
                                      children: [
                                        TextButton(onPressed: () {
                                          _showAlertDialog(context, " Accept Request  ", "Are You Sure ?",_services.Requests.doc().id,_services.toString());
                                        },
                                          child: Text("Accept",
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStatePropertyAll(Colors.green),
                                          ),),
                                        const SizedBox(width: 4),
                                        TextButton(onPressed: (){
                                          _showAlertDialog(context, "Reject Request", "Are You Sure ?",_services.Requests.doc().id,'');
                                        }, child: Text("Reject",
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                            style: ButtonStyle(
                                              backgroundColor: MaterialStatePropertyAll(Colors.red),)),
                                      ],
                                    ),
                                  ),
              ]),
                              Divider(thickness: 3,color:Colors.grey),
                            ],
                          ),

                  );

          } return  Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        }
    ),
    ),

      ],
    ),
        );

  }
  _showAlertDialog(context,title, message,status,documentId){
    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
      title: Center(
        child: Text(title),),
      content: Text(message),
      actions: [
        TextButton(onPressed: (){

        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          EasyLoading.show(status: "Confirming");
         status== "Accepted" ?_services.UpdateOrderStatus(documentId,status).then((value) {
            EasyLoading.showSuccess("Request Accepted");
          }):_services.UpdateOrderStatus(documentId,status).then((value) {
           EasyLoading.showSuccess("Request Accepted");
         });
          Navigator.of(context).pop();

        }, child: Text("Confirm")),


      ],
    )
    );
  }
}
