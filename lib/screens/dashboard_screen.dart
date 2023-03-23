import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/services/firebase_services.dart';

class DashScreen extends StatelessWidget {
  static const String id ="Dashboard-screen";
  FirebaseServices _services = FirebaseServices();



  @override
  Widget build(BuildContext context) {

    Widget analatyicalWidget({required String title, String? value} ){
      return   Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: 100,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            border: Border.all(width:5,color: Colors.blueGrey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(title,style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(value!),
                    Icon(Icons.show_chart),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width:10),
      StreamBuilder<QuerySnapshot>(
      stream: _services.users.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
           return Center(
             child: CircularProgressIndicator(),
           );
        }
        if(snapshot.hasData){
          return analatyicalWidget(title: "Total Users", value: snapshot.data!.size.toString());
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
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              return analatyicalWidget(title: "Total Requests", value: snapshot.data!.size.toString());
            }
            return SizedBox();

          },
        ),
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _services.services.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.hasData){
                  return analatyicalWidget(title: "Total Services", value: snapshot.data!.size.toString());
                }
                return SizedBox();
              },
            ),

        StreamBuilder<QuerySnapshot>(
          stream: _services.category.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.hasData){
              return analatyicalWidget(title: "Total Categories", value: snapshot.data!.size.toString());
            }
            return SizedBox();
          },
        ),
          ],
    ),
      ],
    );
  }
}
