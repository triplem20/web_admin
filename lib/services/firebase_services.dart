import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage
      .instance;
  CollectionReference users = FirebaseFirestore.instance.collection("users");
  CollectionReference Requests = FirebaseFirestore.instance.collection("Requests");
  CollectionReference services = FirebaseFirestore.instance.collection("services");
  CollectionReference products = FirebaseFirestore.instance.collection("products");
  CollectionReference category = FirebaseFirestore.instance.collection("categories");


  Future<void> SaveCategory({CollectionReference? reference, Map<String,
      dynamic>? data, String? docName }) {
    return reference!.doc().set(data);
  }


}
