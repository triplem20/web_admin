import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_admin/widgets/update_widget.dart';
import 'package:web_admin/services/firebase_services.dart';

class UpdateForm extends StatefulWidget {
  static const String id ="Update-Button";

   UpdateForm({Key? key,


  }) : super(key: key);

  @override
  State<UpdateForm> createState() => _UpdateFormState();

}

class _UpdateFormState extends State<UpdateForm> {
  FirebaseServices _services = FirebaseServices();

  TextEditingController nameController =TextEditingController();
  TextEditingController priceController =TextEditingController();
  TextEditingController infoController =TextEditingController();


  _buildTextField(TextEditingController controller, String labeledText){
    return Container(
     padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labeledText,
        ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title:Text('Update'),),
      body:  StreamBuilder<QuerySnapshot>(
          stream: _services.services.snapshots(),
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
        ListView(
          children: <Widget>[
            _buildTextField(nameController, 'Name'),
            SizedBox(height: 20),
            _buildTextField(priceController, 'Price'),
            SizedBox(height: 20),
            _buildTextField(infoController, 'Description'),


          ],

        );

    } return  Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
  ),
    );

  }

}
