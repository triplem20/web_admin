import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../services/firebase_services.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  FirebaseServices _services = FirebaseServices();
  TextEditingController categoryController =TextEditingController();
  QuerySnapshot? querySnapshot;
  dynamic image;
  String? fileName;
  final _formkey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {


    deleteCategory(id)async{

      _services.category.doc(id).delete();
      EasyLoading.showSuccess("Category Deleted");

    }
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

    _showAlertDialog(context,title, message, id)async {
      showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
          title: Center(child: Text(title),),
          content: Text(message),
          actions: <Widget>[
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Cancel")),
            TextButton(onPressed: (){
              deleteCategory(id);
              Navigator.of(context).pop();
            }, child: Text("Delete")),


          ],
        ),


      );
    }


    return StreamBuilder<QuerySnapshot>(
      stream: _services.category.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data!.size == 0) {
          return Center(child: Text("No Category Found"));
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
                  leading:  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(data['image'])),
                      borderRadius: BorderRadius.circular(20),
                    ),

                  ),
                  subtitle: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(data['catname']),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {

                                categoryController.text = snapshot.data!
                                    .docs[index]['catname'];

                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) =>
                                        Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView(
                                              shrinkWrap: true,
                                              children: <Widget>[
                                              Form(
                                              key: _formkey,
                                              child: Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text("Update Category :",
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
                                                                    child:  Container(
                                                                        height: 100,
                                                                        width: 100,
                                                                        decoration: BoxDecoration(
                                                                          image: DecorationImage(image: NetworkImage(snapshot.data!.docs[index]['image'])),
                                                                          borderRadius: BorderRadius.circular(20),
                                                                        ),
                                                                    )
                                                                ),
                                                            ),
                                                            Column(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.all(10.0),
                                                                  child: Container(
                                                                    width: 200,
                                                                    height: 200,
                                                                    child:
                                                                    TextFormField(
                                                                      controller: categoryController,
                                                                        validator: (value){
                                                                  if(value!.isEmpty){
                                                                  return "Enter The Category Name";
                                                                  }
                                                                  return null;
                                                                  },
                                                                      decoration: InputDecoration(
                                                                        label: Text("Category Name"),
                                                                        contentPadding:EdgeInsets.zero,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [

                                                                    TextButton(onPressed: (){
                                                                      if(_formkey.currentState!.validate()){

                                                                        snapshot.data!.docs[index]
                                                                            .reference
                                                                            .update({
                                                                          'catname': categoryController.text,

                                                                        }).then((value) {
                                                                          Navigator.of(context).pop();
                                                                          EasyLoading.showSuccess("Category Updated");

                                                                        });
                                                                      }
                                                                      EasyLoading.show(status: 'Updating..');


                                                                    },
                                                                      child: Text(" Update",
                                                                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(Colors.blue),
                                                                      ),),
                                                                    const SizedBox(width: 5),
                                                                    TextButton(onPressed: (){
                                                                    Navigator.of(context).pop();

                                                                    }, child: Text("Cancel",
                                                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                                                        style: ButtonStyle(
                                                                          backgroundColor: MaterialStatePropertyAll(Colors.blue),)),
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          ]
                                                      ),
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
                            child: IconButton(onPressed: () {
                              _showAlertDialog(context, "Delete Category ", "Are You Sure ?",data.id);
                            },
                              icon: Icon(Icons.delete),),
                          ),


                        ],
                      ),
                    ),
                  ),
                  trailing: SizedBox(width: 20),
                ),
              );
            });
      },
    );
  }

}
