import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_admin/widgets/update_widget.dart';

class UpdateButton extends StatefulWidget {
  static const String id ="Update-Button";

  const UpdateButton({Key? key,
  required this.catId,

  }) : super(key: key);
  final String catId;



  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Update'),),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.catId)
          .snapshots(),
          builder:(context, snapshot){
    if(!snapshot.hasData){
    return const CircularProgressIndicator();
    }
    var output =snapshot.data!.data();
    var nameValue = output!['catname'];
print(nameValue);

    return Padding(padding: const EdgeInsets.all(25),
      child: UpdateWidget(
        title: nameValue,
      cat:widget.catId,
      ),
    );
    },
  ),
    );

  }

}
