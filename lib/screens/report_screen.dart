import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var stream;
  int tag = 0;
  List<String> options = [
    "All Requests",
    "Accepted Requests",
    "Rejected Requests",
    "Newest",
    "Oldest",
  ];
  String? accepted;

  filter(val) {
    if (val == 1) {
      setState(() {
        accepted = "Accepted";
      });
    }
    if (val == 2) {
      setState(() {
        accepted = "Accepted";
      });
    }
    if (val == 0) {
      setState(() {
        accepted = null;
      });
    }
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
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
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
                    stream =
                        _services.Requests.where('date', isEqualTo: 'Tomorrw')
                            .snapshots();
                  }
                  if (val == 4) {
                    stream = _services.Requests.where('date',
                            isEqualTo: 'Within this week')
                        .snapshots();
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                  source: options, value: (i, v) => i, label: (i, v) => v),
            ),
          ),
          const SizedBox(height: 20),
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
                  width: 100,
                  child: Text(
                    'Request ID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    'User ID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    'Username',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    'Service ID',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
                  child: Text(
                    'Date',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: 100,
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
                      itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 120,
                                  child: Text(data.docs[index]['id']),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(data.docs[index]['productId']),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(
                                      snapshot.data!.docs[index]['productId']),
                                ),
                                Container(
                                  width: 120,
                                  child: Text(
                                      'on ${data.docs[index]['date'].toString()}'),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        data.docs[index]['status'] == "Accepted"
                                            ? Colors.blue
                                            : data.docs[index]['status'] ==
                                                    "Rejected"
                                                ? Colors.blue
                                                : Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  width: 120,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Center(
                                        child: Text(
                                      data.docs[index]['status'],
                                      style: TextStyle(
                                          color: data.docs[index]['status'] ==
                                                  "Pending"
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
