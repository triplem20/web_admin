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
  dynamic dropdownValue3;
  QuerySnapshot? querySnapshot3;


  var stream;

  int tag = 0;
  List<String> options = [
    "All Requests",
    "Home Services",
    "Office Service",
    "Building Service",
  ];

  @override
  Widget _dropDownButton() {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward,color: Colors.greenAccent,),
      hint: Text('Select Category'),
      onChanged: (String? newValue) {

        // This is called when the user selects an item
        setState(() {
          dropdownValue = newValue!;



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
    getCategory2List();
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
        insetPadding: EdgeInsets.symmetric(vertical:100,horizontal: 100),
        title: Row(
          children: [
            Icon(Icons.delete_forever,color: Colors.red,),
            SizedBox(width: 3),
            Center(
              child: Text(title),
            ),
          ],
        ),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel",style: TextStyle(color: Colors.greenAccent),)),
          ElevatedButton(
              style: ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.red),),
              onPressed: () {
                deleteCategory(id);
                Navigator.of(context).pop();
              },
              child: Text("Delete",style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }

  Widget _dropDownButton3() {
    return DropdownButton<String>(
      style: TextStyle(fontSize: 15),

      elevation: 8,
      value: dropdownValue3,
      icon: const Icon(Icons.arrow_downward),
      hint: Text('Select Category'),
      onChanged: (String? newValue3) {

        // This is called when the user selects an item.
        setState(() {
          dropdownValue3 = newValue3!;
          stream = _services.services.where('category', isEqualTo: dropdownValue3)
              .snapshots();


        });
      },
      items: querySnapshot3!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['name'],
          child: Text(e["name"]),
        );
      }).toList(),

    );
  }
  getCategory2List(){
    return _services.category.get().then((QuerySnapshot qs3) {
      setState(() {
        querySnapshot3 = qs3;
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          Text("Category : ",style: TextStyle(color: Colors.green),),
          SizedBox(width: 3),
          Container(
              child: querySnapshot == null ? CircularProgressIndicator(color: Colors.greenAccent) :_dropDownButton3()),

        ],),
        StreamBuilder<QuerySnapshot>(
            stream:stream ??
                FirebaseFirestore.instance
                    .collection("services")
                    .snapshots(),
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
                  childAspectRatio: 7/2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
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
                                    dropdownValue =snapshot.data!.docs[index]['category'];
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
                                                                  : _dropDownButton(),
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
                                                                            maxLines: 9,
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
                                                                              contentPadding: EdgeInsets.all(5),
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


                                                                  ElevatedButton(
                                                                      onPressed: () {
                                                                        Navigator.of(context).pop();
                                                                      },
                                                                      child: Text(
                                                                          "Cancel",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .greenAccent,
                                                                              fontWeight:
                                                                                  FontWeight
                                                                                      .bold)),
                                                                      style:
                                                                          ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStatePropertyAll(
                                                                                Colors
                                                                                    .white),
                                                                      )),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  ElevatedButton(
                                                                    onPressed: () {

                                                                      if(dropdownValue != null) {
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
                                                                            'image':imageUrlController.text,


                                                                          })
                                                                              .then((value) {
                                                                            Navigator
                                                                                .of(
                                                                                context)
                                                                                .pop();
                                                                            EasyLoading
                                                                                .showSuccess(
                                                                                "Service Updated");
                                                                          });
                                                                        }

                                                                        EasyLoading.instance
                                                                          ..displayDuration =const Duration(milliseconds: 2000)
                                                                          ..loadingStyle =EasyLoadingStyle.light;
                                                                        EasyLoading.show(status: 'Updating..',dismissOnTap: true);
                                                                      }
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
            }),
      ],
    );
  }
}
