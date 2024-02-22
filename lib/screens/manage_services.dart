import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/widgets/service_list.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:file_picker/file_picker.dart';

class ServiceScreen extends StatefulWidget {
  static const String id ="Service-screen";



  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  FirebaseServices _services = FirebaseServices();
  TextEditingController _sername =TextEditingController();
  TextEditingController _info =TextEditingController();
  TextEditingController _price =TextEditingController();
  TextEditingController _image =TextEditingController();


  final _formkey = GlobalKey<FormState>();
  dynamic dropdownValue;
  QuerySnapshot? querySnapshot;




  clean(){
    setState(() {
      _sername.clear();
      _info.clear();
      _price.clear();
      dropdownValue== null;
      _image.clear();
    });
  }
  saveServiceTofirebase()async {
    _services.SaveCategory(
      data: {
        'category': dropdownValue,
        'title': _sername.text,
        'Description': _info.text,
        'Price': _price.text,
        'image':_image.text,
      },
      reference: _services.services,

    ).then((value) {
      EasyLoading.showSuccess('Service Added');
      EasyLoading.dismiss();
      clean();
    });
  }

  @override
  Widget _dropDownButton() {
    return DropdownButton<String>(

      elevation: 8,
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
          value: e['name'],
          child: Text(e["name"]),
        );
      }).toList(),

    );
  }
  getCategoryList(){
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



  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Add Service :",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            SizedBox(height: 10),
            querySnapshot == null ? CircularProgressIndicator(color: Colors.greenAccent) : _dropDownButton(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
               SizedBox(width:10),

                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        height: 100,
                        child:
                        TextFormField(
                          controller: _sername,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter The Service Name";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text("Enter Service Name"),
                            contentPadding:EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 200,
                        height:100,
                        child:
                        TextFormField(
                          controller: _info,
                          maxLines: 5,
                          minLines: 1,
                          keyboardType: TextInputType.multiline  ,
                          validator: (value){
                            if(value!.isEmpty){
                              return"Enter The Service Description";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text("Enter Service Description"),
                            contentPadding:EdgeInsets.all(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        width: 200,
                        height: 100,
                        child:
                        TextFormField(
                          controller: _price,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                          onChanged: (value) {
                            double.parse(value);
                          },

                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Service Price ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text("Enter Service Price SDG "),
                            contentPadding:EdgeInsets.zero,
                          ),
                        ),
                      ),

                      SizedBox(height: 5),
                      Container(
                        width: 200,
                        height: 100,
                        child:
                        TextFormField(
                          maxLines: 3,
                          minLines: 1,
                          keyboardType: TextInputType.multiline  ,
                          controller: _image,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter Image URL ";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Text("Enter Image URL"),
                            contentPadding:EdgeInsets.zero,
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

                ElevatedButton(onPressed: (){
                  EasyLoading.dismiss();
                  clean();
                }, child: Text("Cancel",
                    style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),)),
                const SizedBox(width: 5),
                ElevatedButton(onPressed: (){
                  if(dropdownValue != null){

                    if(_formkey.currentState!.validate()){
                      EasyLoading.instance
                        ..displayDuration =const Duration(milliseconds: 2000)
                        ..loadingStyle =EasyLoadingStyle.light;
                      EasyLoading.show(status: 'Saving..');
                      saveServiceTofirebase();



                    }
                  }



                },
                  child: Text(" Save ",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),
                  ),),

              ],
            ),
            SizedBox(height: 10),


            Divider(thickness: 5,color: Colors.green),
            SizedBox(height: 10),
            Text("All Services :", style: TextStyle(color: Colors.green, fontSize: 20),),
            SizedBox(height: 10),
            ServiceList(),

          ],
        ),
      ),
    );
  }
}
