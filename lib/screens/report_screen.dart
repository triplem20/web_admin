import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  static const String id = "Report-Screen";

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  FirebaseServices _services = FirebaseServices();
  TextEditingController dateController =TextEditingController();
  TextEditingController dateController2 =TextEditingController();
  dynamic dropdownValue;
  dynamic dropdownValue2;
  dynamic dropdownValue3;
  String? formattedDate;
  String? formattedDate2;
  QuerySnapshot? querySnapshot;
  QuerySnapshot? querySnapshot2;
  QuerySnapshot? querySnapshot3;




  var stream;
  String? selectedOption;
  int tag = 0;
  List<String> options = [
    "All Requests",
    "Accepted Requests",
    "Rejected Requests",
    "Canceled Requests",
    "Newest To Oldest",
    "Oldest To Newest",
  ];





  @override
  Widget _datepick1(){
    return Center(
      child: TextField(
        controller: dateController,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: "Start Date",
        ),
        readOnly: true,
        onTap: ()async{
          DateTime? pickDate=await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
          );
          if(pickDate!=null){
            formattedDate=DateFormat("yyyy-MM-dd").format(pickDate);

            setState(() {
              dateController.text=formattedDate.toString();
            });
          }else{
            print("select date");
          }
        },
      ) ,
    );

  }
  @override
  Widget _datepick2(){
    return Center(
      child: TextField(
        controller: dateController2,
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today),
          labelText: "End Date",
        ),
        readOnly: true,
        onTap: ()async{
          DateTime? pickDate2=await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if(pickDate2 !=null){
             formattedDate2 =DateFormat("yyyy-MM-dd").format(pickDate2);

            setState(() {
              dateController2.text=formattedDate2.toString();

            });
          }else{
            print("select date");
          }
        },
      ) ,
    );

  }
  _showAlertDialog(context) async {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical:150,horizontal: 40),
        title: Center(
         child: Text("Select Dates"),
        ),
        content: Column(
          children: [
            _datepick1(),
            SizedBox(height: 5),
            _datepick2(),
          ],
        ),
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
                setState(() {
                  stream =_services.Requests.where('id',isGreaterThanOrEqualTo: formattedDate).where('id',isLessThanOrEqualTo: formattedDate2).snapshots();
                  Navigator.of(context).pop();
                });

              },
              child: Text("Apply",style: TextStyle(color: Colors.white),)),
        ],
      ),
    );
  }
  @override
  Widget _dropDownButton1() {
    return DropdownButton<String>(
      style: TextStyle(fontSize: 15),

      elevation: 8,
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      hint: Text('Select Email'),
      onChanged: (String? newValue) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = newValue!;
          stream = _services.Requests.where('email', isEqualTo: dropdownValue)
              .snapshots();


        });
      },
      items: querySnapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['email'],
          child: Text(e["email"]),
        );
      }).toList(),

    );
  }
  getUsersList(){
    return _services.users.get().then((QuerySnapshot qs) {
      setState(() {
        querySnapshot = qs;
      });
    });
  }

  Widget _dropDownButton2() {
    return DropdownButton<String>(
      style: TextStyle(fontSize: 15),

      elevation: 8,
      value: dropdownValue2,
      icon: const Icon(Icons.arrow_downward),
      hint: Text('Select Service'),
      onChanged: (String? newValue2) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue2 = newValue2!;
          stream = _services.Requests.where('title',isEqualTo: dropdownValue2).snapshots();



        });
      },
      items: querySnapshot2!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['title'],
          child: Text(e["title"]),
        );
      }).toList(),

    );
  }
  getServicesList(){
    return _services.services.get().then((QuerySnapshot qs2) {
      setState(() {
        querySnapshot2 = qs2;
      });
    });
  }

  @override
  void initState() {
    getUsersList();
    getServicesList();

    dateController.text="";
    dateController2.text="";

    // TODO: implement initState
    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            "Reports",
            style: TextStyle(color: Colors.green, fontSize: 30),
          ),
          const SizedBox(height: 5),
          Container(
            height: 210,
            width: MediaQuery.of(context).size.width,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Sort By : ",style: TextStyle(fontSize: 20,color:Colors.green),),
                Row(
                  children: [
                    Text("Other :",style: TextStyle(color: Colors.green),),
                    SizedBox(width: 3),
                    Container(
                      child: ChipsChoice.single(
                        value: tag,
                        onChanged: (val) {
                          setState(() {
                            tag = val;
                            if (val == 0) {
                              stream = FirebaseFirestore.instance
                                  .collection("Requests")
                                  .snapshots();
                            }
                            if (val == 1) {
                              stream = _services.Requests.where('status',
                                  isEqualTo: 'Accepted')
                                  .snapshots();
                            }
                            if (val == 2) {
                              stream = _services.Requests.where('status',
                                  isEqualTo: 'Rejected')
                                  .snapshots();
                            }
                            if (val == 3) {
                              stream = _services.Requests.where('status',
                                  isEqualTo: 'Canceled')
                                  .snapshots();
                            }
                            if (val == 4) {
                              stream = _services.Requests.orderBy('id',descending: true)
                                  .snapshots();
                            }
                            if (val == 5) {
                              stream = _services.Requests.orderBy('id',descending: false)
                                  .snapshots();
                            }



                          });
                        },
                        choiceItems: C2Choice.listFrom<int, String>(
                            source: options, value: (i, v) => i, label: (i, v) => v),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Text("Date : ",style: TextStyle(color: Colors.green),),
                    SizedBox(width: 3),
                    Container(child: ElevatedButton(
                        style:  ButtonStyle( backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),),
                        onPressed: (){
                          _showAlertDialog(context);
                        }, child: Text("Date Range",style: TextStyle(color: Colors.white),))),
                  ],
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Text("User Email : ",style: TextStyle(color: Colors.green),),
                    SizedBox(width: 3),
                    Container(
                        child: querySnapshot == null ? CircularProgressIndicator(color: Colors.greenAccent) :_dropDownButton1()),
                    SizedBox(width: 10),
                    Text("Service : ",style: TextStyle(color: Colors.green),),
                    SizedBox(width: 3),
                    Container(
                        child: querySnapshot2 == null ? CircularProgressIndicator(color: Colors.greenAccent) :_dropDownButton2()),
                    SizedBox(width: 10),

                  ],
                ),


              ],
            ),
          ),
          SizedBox(height: 2),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 120,
                  child: Text(
                    'Request Date',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  width: 120,
                  child: Text(
                    'Service ID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 120,
                  child: Text(
                    'User Email',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 120,
                  child: Text(
                    'UserID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 120,
                  child: Text(
                    'Service Date',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 120,
                  child: Text(
                    'Request Status',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 600,
            child: StreamBuilder(
                stream: stream ??
                    FirebaseFirestore.instance
                        .collection("Requests")
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No Data");
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot.data!.size == 0) {
                    return Center(
                      child: Text("No Requests"),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.greenAccent,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    var data = snapshot.requireData;
                    return ListView.builder(
                      itemCount: data.size,
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(DateFormat.yMMMd().add_jm().format(DateTime.parse('${data.docs[index]['id']}'))),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(data.docs[index]['serviceid']),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                      snapshot.data!.docs[index]['email']),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                      snapshot.data!.docs[index]['uid']),
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                      '${data.docs[index]['date'].toString()}'),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        data.docs[index]['status'] == "Accepted"
                                            ? Colors.blue
                                            : data.docs[index]['status'] ==
                                                    "Rejected"
                                                ? Colors.blue
                                                :
                                    data.docs[index]['status'] ==
                                        "Canceled"
                                      ? Colors.grey
                                    :Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text(
                                      data.docs[index]['status'],
                                      style: TextStyle(
                                          color: data.docs[index]['status'] ==
                                                  "in Progress"
                                              ? Colors.black
                                              : Colors.white),
                                    )),
                                  ),
                                ),
                              ]),
                          Divider(thickness: 3, color: Colors.grey),
                        ],
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.greenAccent,
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



}
