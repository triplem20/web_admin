import 'package:flutter/material.dart';



class ChangepassScreen extends StatefulWidget {
  static const String id ="Changepass-Screen";


  @override
  State<ChangepassScreen> createState() => _ChangepassScreenState();
}

class _ChangepassScreenState extends State<ChangepassScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Change Password"),
      ),
    );
  }
}
