import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateWidget extends StatefulWidget {

  UpdateWidget({required this.title , required this.cat}) ;

  final String title;
  final String cat;


  @override
  State<UpdateWidget> createState() => _UpdateWidgetState();
}


class _UpdateWidgetState extends State<UpdateWidget> {


  TextEditingController titleController = TextEditingController();




  @override
  void initState() {
    titleController.text= widget.title;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        TextFormField(
          controller: titleController,
          validator: (value){
            if(value!.isEmpty){
              return"Enter The Category Name";
            }
            return null;
          },
          decoration: InputDecoration(
            label: Text("Enter Category Name"),
            contentPadding:EdgeInsets.zero,
          ),
        ),
        ElevatedButton(onPressed: (){
          var collection= FirebaseFirestore.instance.collection("categories");


              collection
              .doc(widget.cat)
              .update({
            'catname': titleController.text,


          });

          Navigator.pop(context);
        }, child: Text("Update"),),

      ],
    );
  }
}
