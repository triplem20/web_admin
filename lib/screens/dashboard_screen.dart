import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/services/firebase_services.dart';

class DashScreen extends StatelessWidget {
  static const String id ="Dashboard-screen";
  FirebaseServices _services = FirebaseServices();



  @override
  Widget build(BuildContext context) {

    Widget analatyicalWidget({required String title, String? value,Color? color} ){
      return   Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 110,
            width: 120,
            decoration: BoxDecoration(
              color: color,

              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(title,style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(value!,style: TextStyle(fontSize: 30,color: Colors.white,  fontWeight: FontWeight.bold),),
                      Icon(Icons.show_chart,color: Colors.white,size: 25,),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return
      Container(
        child: Column(


          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            const SizedBox(height:10),
        Row(
        children: [
          const SizedBox(width:10),
        StreamBuilder<QuerySnapshot>(
        stream: _services.users.where('role',isEqualTo: "user").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
             return Center(
               child: CircularProgressIndicator(color: Colors.green),
             );
          }
          if(snapshot.hasData){
            return analatyicalWidget(title: "Total Users", value: snapshot.data!.size.toString(),color: Colors.green,);
          }
         return SizedBox();

            },
          ),

          const SizedBox(width:10),

          StreamBuilder<QuerySnapshot>(
            stream: _services.category.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.black45),
                );
              }
              if(snapshot.hasData){
                return analatyicalWidget(title: "Total Categories", value: snapshot.data!.size.toString(),color: Colors.black45);
              }
              return SizedBox();
            },
          ),


          ]
    ),
          Row(
            children: [
              const SizedBox(width:10),
              StreamBuilder<QuerySnapshot>(
                stream: _services.services.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.brown),
                    );
                  }
                  if(snapshot.hasData){
                    return analatyicalWidget(title: "Total Services", value: snapshot.data!.size.toString(),color: Colors.brown);
                  }
                  return SizedBox();
                },
              ),
              const SizedBox(width:10),
              StreamBuilder<QuerySnapshot>(
                stream: _services.Requests.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.orangeAccent),
                    );
                  }
                  if(snapshot.hasData){
                    return analatyicalWidget(title: "Total Requests", value: snapshot.data!.size.toString(),color: Colors.orangeAccent);
                  }
                  return SizedBox();

                },
              ),
            ],
    ),
            SizedBox(height:35),
            Row(
              children: [
                SizedBox(width:10),
                StreamBuilder<QuerySnapshot>(
                  stream: _services.Requests.where('status',isEqualTo: 'in Progress').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
                      );
                    }
                    if(snapshot.hasData){
                      return analatyicalWidget(title: "Pending Requests", value: snapshot.data!.size.toString(),color: Colors.deepOrangeAccent);
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(width:10),
                StreamBuilder<QuerySnapshot>(
                  stream: _services.Requests.where('status',isEqualTo: 'Rejected').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.redAccent),
                      );
                    }
                    if(snapshot.hasData){
                      return analatyicalWidget(title: "Rejected Requests", value: snapshot.data!.size.toString(),color: Colors.redAccent);
                    }
                    return SizedBox();
                  },
                ),
                SizedBox(width:10),
                StreamBuilder<QuerySnapshot>(
                  stream: _services.Requests.where('status',isEqualTo: 'Accepted').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.greenAccent),
                      );
                    }
                    if(snapshot.hasData){
                      return analatyicalWidget(title: "Accepted Requests", value: snapshot.data!.size.toString(),color: Colors.greenAccent);
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),


    ]
    ),
      );
  }
}
