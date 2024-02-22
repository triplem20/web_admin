
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'package:intl/intl.dart';






class RequestsScreen extends StatefulWidget {
  static const String id ="Requests-Screen";

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  FirebaseServices _services = FirebaseServices();

  TextEditingController statusController = TextEditingController();

  var stream;
  int tag = 0;
  List<String> options = [
    "All Requests",
    "Pending",
  ];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            "Requests", style: TextStyle(color: Colors.green, fontSize: 30),),
          const SizedBox(height: 20),
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
                        isEqualTo: 'in Progress')
                        .snapshots();
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                  source: options, value: (i, ii) => i, label: (i, ii) => ii),
            ),
          ),

          Container(height: 60,
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
                  width: 100,
                  child: Text('Request Date', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Category', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Service Name', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('UserName', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('User ID', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),
                Container(
                  width: 100,
                  child: Text('Service Date', style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),),
                ),

                Container(
                  width: 250,
                  child: Text('              '),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 600,


            child:
            StreamBuilder<QuerySnapshot>(
                stream: stream ??
                    FirebaseFirestore.instance
                        .collection("Requests").where('status', isNotEqualTo: 'Canceled')
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("No Data");
                  }
                  if (snapshot.hasError) {
                    return Text("Error");
                  }
                  if (snapshot == null) {
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
                      itemBuilder: (context, index) =>
                          Column(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Text(
                                          DateFormat.yMMMd().add_jm().format(
                                              DateTime.parse('${data
                                                  .docs[index]['id']}'))),
                                    ),
                                    Container(
                                      width: 120,
                                      child: Text(snapshot.data!
                                          .docs[index]['category']),
                                    ),
                                    Container(
                                      width: 120,
                                      child: Text(
                                          snapshot.data!.docs[index]['title']),
                                    ),

                                    Container(
                                      width: 120,
                                      child: Text("${snapshot.data!
                                          .docs[index]['userName']}"),
                                    ),
                                    Container(
                                      width: 120,
                                      child: Text("${snapshot.data!
                                          .docs[index]['uid']}"),
                                    ),

                                    Container(
                                      width: 120,
                                      child: Text(
                                          snapshot.data!.docs[index]['date']),
                                    ),


                                    Container(
                                      width: 250,
                                      child:
                                      snapshot.data!.docs[index]['status'] ==
                                          'Accepted' ?
                                      Center(
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white38,
                                              borderRadius: BorderRadius
                                                  .circular(5),
                                            ),

                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                  10.0),
                                              child: Text("Accepted",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight
                                                        .bold),),
                                            )
                                        ),
                                      ) : Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              ElevatedButton(onPressed: () {
                                                showCupertinoDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (
                                                        BuildContext context) =>
                                                        AlertDialog(
                                                          title: Row(
                                                            children: [
                                                              Icon(Icons.task_alt,color: Colors.green),
                                                              SizedBox(width: 3),
                                                              Center(
                                                                child: Text(
                                                                  "Accept Request",),),
                                                            ],
                                                          ),
                                                          content: Text(
                                                            "Are You Sure?",),
                                                          actions: [
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStatePropertyAll(
                                                                      Colors
                                                                          .white),),
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    "Cancel",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .greenAccent,
                                                                        fontWeight: FontWeight
                                                                            .bold))),
                                                            ElevatedButton(
                                                                style: ButtonStyle(
                                                                  backgroundColor: MaterialStatePropertyAll(
                                                                      Colors
                                                                          .greenAccent),),
                                                                onPressed: () async{
                                                                  snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                      .reference
                                                                      .update({

                                                                    'status': "Accepted",


                                                                  })
                                                                      .then((
                                                                      value) {
                                                                    Navigator
                                                                        .of(
                                                                        context)
                                                                        .pop();
                                                                    EasyLoading.instance
                                                                      ..displayDuration =const Duration(milliseconds: 2000)
                                                                      ..loadingStyle =EasyLoadingStyle.light;
                                                                    EasyLoading
                                                                        .showSuccess(
                                                                        "Request Accepted");
                                                                  });
                                                                  encodeQueryParameters(Map<String, String> params) {
                                                                    return params.entries
                                                                        .map((MapEntry<String, String> e) =>
                                                                    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                                                                        .join('&');
                                                                  }
                                                                  final Uri emailUri = Uri(
                                                                    scheme: 'mailto',
                                                                    path: "${snapshot.data!
                                                                        .docs[index]['email']}",
                                                                    query: encodeQueryParameters(<String, String>{
                                                                      'subject' : 'Top Care Company Service Request Status',
                                                                      'body' : 'Your Request Has been Accepted ! Please contact the company to confirm your location.',
                                                                    }),
                                                                  );
                                                                  if( await canLaunchUrl(emailUri)){
                                                                  launchUrl(emailUri);
                                                                  }else{
                                                                    throw Exception('could not launch $emailUri');
                                                                  }

                                                                },
                                                                child: Text(
                                                                  "Accept",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),)),
                                                          ],
                                                        )
                                                );
                                              },
                                                child: Text("  Accept  ",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight
                                                            .bold)),
                                                style: ButtonStyle(
                                                  backgroundColor: MaterialStatePropertyAll(
                                                      Colors.green),
                                                ),),
                                              SizedBox(width: 3),

                                              AbsorbPointer(
                                                absorbing: snapshot.data!
                                                    .docs[index]['status'] ==
                                                    'Rejected'
                                                    ? true
                                                    : false,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      showCupertinoDialog(
                                                          context: context,
                                                          barrierDismissible: false,
                                                          builder: (
                                                              BuildContext context) =>
                                                              AlertDialog(
                                                                title: Row(
                                                                  children: [
                                                                    Icon(Icons.dangerous_outlined,color: Colors.red),
                                                                    SizedBox(width: 3),
                                                                    Center(
                                                                      child: Text(
                                                                          "Reject Request"),),
                                                                  ],
                                                                ),
                                                                content: Text(
                                                                    "Are You Sure?"),
                                                                actions: [
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(
                                                                            Colors
                                                                                .white),),
                                                                      onPressed: () {
                                                                        Navigator
                                                                            .of(
                                                                            context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          "Cancel",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .greenAccent,
                                                                              fontWeight: FontWeight
                                                                                  .bold))),
                                                                  ElevatedButton(
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStatePropertyAll(
                                                                            Colors
                                                                                .greenAccent),),
                                                                      onPressed: ()async {
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .reference
                                                                            .update(
                                                                            {

                                                                              'status': "Rejected",


                                                                            })
                                                                            .then((
                                                                            value) {
                                                                          Navigator
                                                                              .of(
                                                                              context)
                                                                              .pop();
                                                                          EasyLoading.instance
                                                                            ..displayDuration =const Duration(milliseconds: 2000)
                                                                            ..loadingStyle =EasyLoadingStyle.light;
                                                                          EasyLoading
                                                                              .showSuccess(
                                                                              "Request Rejected");
                                                                        });
    encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    }
    final Uri emailUri = Uri(
    scheme: 'mailto',
    path: "${snapshot.data!
        .docs[index]['email']}",
    query: encodeQueryParameters(<String, String>{
    'subject' : 'Top Care Company Service Request Status',
    'body' : 'We are sorry to inform you that Your Request Has been unfortunately Rejected ',
    }),
    );
    if( await canLaunchUrl(emailUri)){
    launchUrl(emailUri);
    }else{
    throw Exception('could not launch $emailUri');
    }

                                                                      },
                                                                      child: Text(
                                                                          "Reject",
                                                                          style: TextStyle(
                                                                              color: Colors
                                                                                  .white,
                                                                              fontWeight: FontWeight
                                                                                  .bold))),
                                                                ],
                                                              )
                                                      );
                                                    },
                                                    child: Text(snapshot.data!
                                                        .docs[index]['status'] ==
                                                        'Rejected'
                                                        ? "Rejected"
                                                        : "  Reject  ",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: snapshot
                                                                .data!
                                                                .docs[index]['status'] ==
                                                                'Rejected'
                                                                ? Colors.red
                                                                : Colors.white
                                                        )),
                                                    style: ButtonStyle(
                                                      backgroundColor: MaterialStatePropertyAll(
                                                          snapshot.data!
                                                              .docs[index]['status'] ==
                                                              'Rejected'
                                                              ? Colors.white70
                                                              : Colors.red),)),
                                              ),
                                            ],
                                          ),
                                        ),
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
                }
            ),
          ),

        ],
      ),
    );
  }

}
