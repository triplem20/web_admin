import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:intl/intl.dart';


class ReportScreen extends StatefulWidget {
  static const String id ="Report-Screen";

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  FirebaseServices _services = FirebaseServices();




  int tag =0;
  List<String>options =[
    "All Requests",
    "Accepted Requests",
    "Rejected Requests",
  ];
  late bool accepted;

  
  filter(val){
    if(val==1){
      setState(() {
        accepted =true;
      });
    }
    if(val==2){
      setState(() {
        accepted =true;
      });
    }
    if(val==0){
      setState(() {
        accepted = false;

      });
    }
  }
  
  

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:Column(
        children: [
          Text("Reports",style: TextStyle(color: Colors.green, fontSize: 30),),
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice.single(

                value: tag,
                onChanged: (val){
                  setState(() {
                   tag= val;
                  });
                },
              choiceItems: C2Choice.listFrom<int, String>(
                  source:options,
                  value: (i,iii)=> i,
                  label: (i,iii)=> iii
              ),


            ),
          ),
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
                  child: Text('Request ID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('User ID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),

                Container(
                  width: 100,
                  child: Text('Username',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Service ID',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),

                Container(
                  width: 100,
                  child: Text('Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Request Status',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

           Container(
            height: 600,
            child:
            StreamBuilder<QuerySnapshot>(
                stream: _services.Requests.where('request status', isEqualTo: accepted)
                    .snapshots(),
                builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.hasError){
                    return Text("Error");
                  }
                  if(snapshot.data!.size==0){
                    return Center(
                      child: Text("No Requests"),
                    );
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
                                        child: Text(snapshot.data!.docs[index]['productId']),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text(snapshot.data!.docs[index]['Username']),
                                      ),

                                      Container(
                                        width: 120,
                                        child: Text(snapshot.data!.docs[index]['productId']),
                                      ),
                                      Container(
                                        width: 120,
                                        child: Text('on ${DateFormat.yMMMd().format(snapshot.data!.docs[index]['Order Date'].toDate())}'),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        width: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Center(child: snapshot.data!.docs[index]['request status']),
                                        ),
                                      ),






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


