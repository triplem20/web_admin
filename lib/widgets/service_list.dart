import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/services.dart';



import '../services/firebase_services.dart';

class ServiceList extends StatefulWidget {
  const ServiceList({Key? key}) : super(key: key);

  @override
  State<ServiceList> createState() => _ServiceListState();
}

class _ServiceListState extends State<ServiceList> {
  FirebaseServices _services = FirebaseServices();

  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  dynamic dropdownValue;
  QuerySnapshot? querySnapshot;

  @override
  Widget _dropDownButton(String? val) {
    return DropdownButton<String>(
      value: val,
      icon: const Icon(Icons.arrow_downward,color: Colors.greenAccent,),
      hint: Text('Select Category'),
      onChanged: (String? newValue) {
        // This is called when the user selects an item
        setState(() {
          val = newValue!;

        });
      },
      items: querySnapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['name'],
          child: Text(e["name"]),
        );
      }).toList(),
    );
  }

  getCategoryList() {
    return _services.category.get().then((QuerySnapshot qs) {
      setState(() {
        querySnapshot = qs;
      });
    });
  }

  @override
  void initState() {
    getCategoryList();
    // TODO: implement initState
    super.initState();
  }
  deleteCategory(id) async {
    _services.services.doc(id).delete();
    EasyLoading.showSuccess("Service Deleted");
  }

  _showAlertDialog(context, title, message, id) async {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Center(
          child: Text(title),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",style: TextStyle(color: Colors.white),)),
          TextButton(
              style: ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
              onPressed: () {
                deleteCategory(id);
                Navigator.of(context).pop();
              },
              child: Text("Delete",style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _services.services.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color:Colors.greenAccent),
            );
          }

          if (snapshot.data!.size == 0) {
            return Center(child: Text("No Service Found"));
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
            ),
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              var data = snapshot.data!.docs[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image:
                            DecorationImage(image: NetworkImage(data['image'])),
                        borderRadius: BorderRadius.circular(20),
                      )),
                  subtitle: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(data['title']),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              color: Colors.green,
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  nameController.text =
                                      snapshot.data!.docs[index]['title'];
                                  infoController.text =
                                      snapshot.data!.docs[index]['Description'];
                                  priceController.text =
                                      snapshot.data!.docs[index]['Price'];
                                  imageUrlController.text =
                                  snapshot.data!.docs[index]['image'];


                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) => Dialog(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: <Widget>[
                                                  Form(
                                                    key: _formkey,
                                                    child: Center(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Update Service :",
                                                            style: TextStyle(
                                                                color: Colors.green,
                                                                fontSize: 20),
                                                          ),
                                                          querySnapshot == null
                                                              ? CircularProgressIndicator(
                                                                  color: Colors
                                                                      .greenAccent)
                                                              : _dropDownButton(snapshot.data!.docs[index]['category']),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.all(10.0),
                                                                child: Column(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Container(
                                                                      width: 200,
                                                                      height: 100,
                                                                      child:
                                                                          TextFormField(
                                                                        controller: nameController,
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Enter The Service Name";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          label: Text("Service Name"),
                                                                          contentPadding: EdgeInsets.zero,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    Container(
                                                                      width: 200,
                                                                      height: 100,
                                                                      child:
                                                                          TextFormField(
                                                                        controller: infoController,
                                                                        maxLines: 5,
                                                                        minLines: 1,
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Enter The Service Description";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          label: Text(" Service Description"),
                                                                          contentPadding: EdgeInsets.zero,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(height: 10),
                                                                    Container(
                                                                      width: 200,
                                                                      height: 100,
                                                                      child:
                                                                          TextFormField(
                                                                        controller: priceController,
                                                                        keyboardType: TextInputType.number,
                                                                        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Enter The Service Price";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        onChanged: (value) {
                                                                          double.parse(
                                                                              value);
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          label: Text(" Service Price SDG"),
                                                                          contentPadding: EdgeInsets.zero,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: 200,
                                                                      height: 100,
                                                                      child:
                                                                          TextFormField(
                                                                        controller: imageUrlController,
                                                                        validator: (value) {
                                                                          if (value!.isEmpty) {
                                                                            return "Enter Image URL";
                                                                          }
                                                                          return null;
                                                                        },
                                                                        decoration: InputDecoration(
                                                                          label: Text("Image URL"),
                                                                          contentPadding: EdgeInsets.zero,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {

                                                                 if (_formkey
                                                                     .currentState!
                                                                     .validate()) {
                                                                   snapshot
                                                                       .data!
                                                                       .docs[index]
                                                                       .reference
                                                                       .update({

                                                                     'title': nameController.text,
                                                                     'category': dropdownValue,
                                                                     'Description': infoController.text,
                                                                     'Price': priceController.text,


                                                                   })
                                                                       .then((
                                                                       value) {
                                                                     Navigator
                                                                         .of(
                                                                         context)
                                                                         .pop();
                                                                     EasyLoading
                                                                         .showSuccess(
                                                                         "Category Updated");
                                                                   });
                                                                 }

                                                                    EasyLoading.show(status: 'Updating..');

                                                                   },
                                                                child: Text("Update",
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold)),
                                                                style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(Colors.greenAccent),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .bold)),
                                                                  style:
                                                                      ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStatePropertyAll(
                                                                            Colors
                                                                                .greenAccent),
                                                                  )),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ));
                                }),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: IconButton(
                              color: Colors.green,
                              onPressed: () {
                                _showAlertDialog(context, "Delete Service ",
                                    "Are You Sure ?", data.id);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
