import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'update_form.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

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
    final _formkey = GlobalKey<FormState>();

    dynamic dropdownValue;
    QuerySnapshot? querySnapshot;
    dynamic image;
    String? fileName;



    @override
    Widget _dropDownButton() {
      return DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        hint: Text('Select Category'),
        onChanged: (String? newValue) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = newValue!;
          });
        },
        items: querySnapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['catname'],
            child: Text(e["catname"]),
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

    pickImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          image = result.files.first.bytes;
          fileName = result.files.first.name;
        });
      } else {
        print("No Image Selected");
      }
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
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
            TextButton(
                onPressed: () {
                  deleteCategory(id);
                  Navigator.of(context).pop();
                },
                child: Text("Delete")),
          ],
        ),
      );
    }

    @override
    void initState() {
      getCategoryList();
      // TODO: implement initState
      super.initState();
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
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data!.size == 0) {
              return Center(child: Text("No Service Found"));
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
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
                    subtitle: Row(
                      children: [
                        Text(data['title']),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              nameController.text =
                              snapshot.data!.docs[index]['title'];
                              infoController.text =
                              snapshot.data!.docs[index]['Description'];
                              priceController.text =
                              snapshot.data!.docs[index]['Price'];

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
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Update Service :",
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 20),
                                                  ),
                                                  querySnapshot == null
                                                      ? CircularProgressIndicator(
                                                      color: Colors.blue)
                                                      : _dropDownButton(),
                                                  Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      Container(
                                                          height: 200,
                                                          width: 200,
                                                          decoration:
                                                          BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8),
                                                            color: Colors
                                                                .blueGrey,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .blue,
                                                                width: 2),
                                                          ),
                                                          child: InkWell(
                                                              onTap: () {
                                                                pickImage();
                                                              },
                                                              child: image ==
                                                                  null
                                                                  ? Center(
                                                                  child: Icon(Icons
                                                                      .file_upload))
                                                                  : Image.memory(
                                                                  image,
                                                                  fit: BoxFit
                                                                      .cover))),
                                                      SizedBox(width: 10),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(10.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Container(
                                                              width: 200,
                                                              height: 100,
                                                              child:
                                                              TextFormField(
                                                                controller:
                                                                nameController,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return "Enter The Service Name";
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration:
                                                                InputDecoration(
                                                                  label: Text(
                                                                      "Service Name"),
                                                                  contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Container(
                                                              width: 200,
                                                              height: 100,
                                                              child:
                                                              TextFormField(
                                                                controller:
                                                                infoController,
                                                                maxLines: 5,
                                                                minLines: 1,
                                                                keyboardType:
                                                                TextInputType
                                                                    .multiline,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return "Enter The Service Description";
                                                                  }
                                                                  return null;
                                                                },
                                                                decoration:
                                                                InputDecoration(
                                                                  label: Text(
                                                                      " Service Description"),
                                                                  contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 10),
                                                            Container(
                                                              width: 200,
                                                              height: 100,
                                                              child:
                                                              TextFormField(
                                                                controller:
                                                                priceController,
                                                                keyboardType:
                                                                TextInputType
                                                                    .number,
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                      .isEmpty) {
                                                                    return "Enter The Service Price";
                                                                  }
                                                                  return null;
                                                                },
                                                                onChanged:
                                                                    (value) {
                                                                  double.parse(
                                                                      value);
                                                                },
                                                                decoration:
                                                                InputDecoration(
                                                                  label: Text(
                                                                      " Service Price"),
                                                                  contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
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
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                    children: [
                                                      image == null
                                                          ? Container()
                                                          : TextButton(
                                                        onPressed: () {
                                                          if (dropdownValue !=
                                                              null) {
                                                            if (_formkey
                                                                .currentState!
                                                                .validate()) {
                                                              EasyLoading.show(
                                                                  status:
                                                                  'Saving..');

                                                            }
                                                          }
                                                        },
                                                        child: Text(
                                                            "Update",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                FontWeight.bold)),
                                                        style:
                                                        ButtonStyle(
                                                          backgroundColor:
                                                          MaterialStatePropertyAll(
                                                              Colors
                                                                  .blue),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 5),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors
                                                                    .blue),
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
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: IconButton(
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
                );
              },
            );
          });
    }
  }


