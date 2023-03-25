import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'update_form.dart';


import '../services/firebase_services.dart';
class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  FirebaseServices _services = FirebaseServices();


  @override
  Widget build(BuildContext context) {
    deleteCategory(id) async {
      _services.services.doc(id).delete();
      EasyLoading.showSuccess("Service Deleted");
    }
    _showAlertDialog(context, title, message, id) async {
      showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Center(child: Text(title),),
              content: Text(message),
              actions: <Widget>[
                TextButton(onPressed: () {
                  Navigator.of(context).pop();
                }, child: Text("Cancel")),
                TextButton(onPressed: () {
                  deleteCategory(id);
                  Navigator.of(context).pop();
                }, child: Text("Delete")),


              ],
            ),


      );
    }


    @override
    Widget ServiceWidget(data) {
      return Container(
        margin: EdgeInsets.all(20),
        width: 300,
        height: 999,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              top: 0,
              right: 0,
              left: 0,
              child:
              Container(
                height: 100,
                width: 100,
                constraints: BoxConstraints(minHeight: 150, minWidth: 150),
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage(data['image'])),
                  borderRadius: BorderRadius.circular(20),
                ),

              ),
            ),
            Positioned(
                top: 5,
                bottom: 0,
                right: 50,
                left: 50,
                child: Text(data['title'])),
            Positioned(
                bottom: 10,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(onPressed: () {
                    _showAlertDialog(
                        context, "Delete Category ", "Are You Sure ?", data.id);
                  },
                    icon: Icon(Icons.delete),),
                )
            ),
            Positioned(
                bottom: 10,
                left: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: IconButton(onPressed: () {
                    Navigator.of(context).pushNamed(UpdateForm.id);
                  },
                    icon: Icon(Icons.edit),),
                )
            ),
          ],
        ),
      );
    }
    return
      StreamBuilder<QuerySnapshot>(
        stream: _services.services.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.size == 0) {
            return Center(child: Text("No Service Found"));
          }


          return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
              ),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return ServiceWidget(data);
              });
        },

      );
  }
}

