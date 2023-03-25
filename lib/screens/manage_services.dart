import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/widgets/service_list.dart';
import 'package:web_admin/services/firebase_services.dart';
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


  final _formkey = GlobalKey<FormState>();
    dynamic dropdownValue;
    QuerySnapshot? querySnapshot;

  dynamic image;
  String? fileName;


  pickImage()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        image = result.files.first.bytes;
        fileName =result.files.first.name;
      });

    }else{
      print("No Image Selected");
    }
  }
  clean(){
    setState(() {
      _sername.clear();
      _info.clear();
      _price.clear();
      dropdownValue== null;
      image=null;
    });
  }
  saveServiceTofirebase()async{
    firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance
        .ref('gs://flutter-topcare.appspot.com/ServiceImages/$fileName');
    EasyLoading.show(status: "Loading..");
    try {
      await ref.putData(image);
      final imageUrl = await ref.getDownloadURL().then((value) =>
      {
        if(value.isNotEmpty){
          _services.SaveCategory(
              data: {
                'category': dropdownValue,
                'title': _sername.text,
                'Description': _info.text,
                'Price':_price.text,
                'image': value,
                'isNew':true,
              },
              reference: _services.services,

          ).then((value) {
            EasyLoading.showSuccess('Service Added');
            EasyLoading.dismiss();
            clean();

          })
        }


      });
    } on firebase_storage.FirebaseException catch (e) {
      print(e.toString());

      clean();
      EasyLoading.dismiss();
    }
  }
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
            style: TextStyle(color: Colors.blue, fontSize: 20),
            ),
             querySnapshot == null ? CircularProgressIndicator(color: Colors.blue) : _dropDownButton(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    height: 200,
                    width:200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color:Colors.blueGrey,
                      border: Border.all(color:Colors.blue,width:2),
                    ),

                    child: InkWell(
                        onTap: (){
                          pickImage();
                        },

                        child: image == null ? Center(child: Icon(Icons.file_upload)):Image.memory(image, fit:BoxFit.cover))),
                SizedBox(width:10),

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
                      SizedBox(height: 10),
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
                            contentPadding:EdgeInsets.zero,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: 200,
                        height: 100,
                        child:
                        TextFormField(

                          controller: _price,
                          keyboardType: TextInputType.number,
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
                            label: Text("Enter Service Price"),
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
                image== null? Container():
                TextButton(onPressed: (){
                  if(dropdownValue != null){
                    if(_formkey.currentState!.validate()){
                      EasyLoading.show(status: 'Saving..');
                      saveServiceTofirebase();


                    }
                  }



                },
                  child: Text("Save",
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                  ),),
                const SizedBox(width: 5),
                TextButton(onPressed: (){
                  EasyLoading.dismiss();
                  clean();
                }, child: Text("Cancel",
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),)),
              ],
            ),
            Divider(thickness: 5,color: Colors.blue),
            SizedBox(height: 10),
            Text("All Services :", style: TextStyle(color: Colors.blue, fontSize: 20),),
            ServiceList(),

          ],
        ),
      ),
    );
  }
}
