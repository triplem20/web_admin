import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:file_picker/file_picker.dart';

import '../widgets/category_list.dart';


class CategoryScreen extends StatefulWidget {
  static const String id ="Category-Screen";

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
final  _formkey =GlobalKey<FormState>();
FirebaseServices _services = FirebaseServices();

TextEditingController _catname =TextEditingController();
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
      _catname.clear();
      image=null;
    });
}
  saveImageTofirebase()async{
  firebase_storage.Reference ref =firebase_storage.FirebaseStorage.instance
      .ref('gs://flutter-topcare.appspot.com/CategoryImages/$fileName');
  EasyLoading.show(status: "Saving..");
   try {
     await ref.putData(image);
     final imageUrl = await ref.getDownloadURL().then((value) =>
     {
       if(value.isNotEmpty){
         _services.SaveCategory(
             data: {
               'catname': _catname.text,
               'image': value
             },
             reference: _services.category,

         ).then((value) {
           EasyLoading.showSuccess("Category Added");
           EasyLoading.dismiss();
           clean();

         }),
       }



     });
    } on firebase_storage.FirebaseException catch (e) {
     print(e.toString());

     clean();
     EasyLoading.dismiss();
   }
    }

  @override
  Widget build(BuildContext context) {
    return  Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Add Categories :",
              style: TextStyle(color: Colors.blue, fontSize: 20),),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
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
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 200,
                        height: 200,
                        child:
                        TextFormField(
                          controller: _catname,
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
                      ),
                    ),
                    Row(
                      children: [
                        image== null? Container():
                        TextButton(onPressed: (){
                          if(_formkey.currentState!.validate()){
                            EasyLoading.show(status: 'Loading..');
                            saveImageTofirebase();
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
                  ],
                ),SizedBox(width: 10),
                Container(
                   height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/images/logo1.jpg')),
                      borderRadius: BorderRadius.circular(20),

                    ),
                )
              ]
            ),
          ),
            Divider(thickness: 3,color: Colors.blue,),
            SizedBox(height: 10),
            Text("All Categories :", style: TextStyle(color: Colors.blue, fontSize: 20),),
            CategoryList(),
          ],
        ),
      ),
    );
  }
}
