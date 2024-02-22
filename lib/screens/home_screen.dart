import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/screens/report_screen.dart';
import 'Admin_screen.dart';
import 'manage_categories.dart';
import 'requests_screen.dart';
import 'dashboard_screen.dart';
import 'manage_services.dart';
import 'users_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String id ="Home-Screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

FirebaseAuth _auth =FirebaseAuth.instance;

Future<String?> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } catch (err) {
    return err.toString();
  }
  return null;
}



class _HomeScreenState extends State<HomeScreen> {
  _showAlertDialog(context,title, message)async {
    showCupertinoModalPopup<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout),
            SizedBox(width: 3),
            Center(child: Text(title),),
          ],
        ),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
            ),onPressed: (){

            Navigator.of(context).pop();
          }, child: Text("Cancel", style: TextStyle(color: Colors.greenAccent,fontWeight: FontWeight.bold)),),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.greenAccent),
            ),
            onPressed: (){

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  LoginScreen(),
                ),
              );



          }, child: Text("Log Out", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),),


        ],
      ),


    );
  }
  Widget _selectedScreen =DashScreen();
  currentScreen(item){
    switch(item.route) {
      case DashScreen.id:
      setState(() {
        _selectedScreen =DashScreen();
      });
        break;
      case ServiceScreen.id:
        setState(() {
          _selectedScreen = ServiceScreen();
        });

        break;
      case RequestsScreen.id:
        setState(() {
          _selectedScreen =RequestsScreen();
        });
        break;
      case UsersScreen.id:
        setState(() {
          _selectedScreen =UsersScreen();
        });
        break;
      case ReportScreen.id:
        setState(() {
          _selectedScreen = ReportScreen();
        });
        break;
      case AdminScreen.id:
        setState(() {
          _selectedScreen = AdminScreen();
        });


    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Top Care'),
        actions: [
          IconButton(onPressed: (){
            _showAlertDialog(context,
              "Log Out ", "Are You Sure ?");
          }, icon: Icon(Icons.logout)),
        ],
      ),
      sideBar: SideBar(
        textStyle: TextStyle(color: Colors.green),
        iconColor: Colors.green,
        activeIconColor: Colors.lightGreenAccent,
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashScreen.id,
            icon: Icons.dashboard,
          ),

          AdminMenuItem(
            title: 'Services',
            route: ServiceScreen.id,
            icon: Icons.cleaning_services,
          ),
          AdminMenuItem(
            title: 'Requests',
            route: RequestsScreen.id,
            icon: Icons.request_page,
          ),
          AdminMenuItem(
            title: 'Users',
            route: UsersScreen.id,
            icon: Icons.person,
          ),
          AdminMenuItem(
            title: 'Reports',
            route: ReportScreen.id,
            icon: Icons.history_edu_outlined,
          ),
          AdminMenuItem(
            title: 'Admin',
            route: AdminScreen.id,
            icon: Icons.person_outline_rounded,
          ),


        ],
        selectedRoute: HomeScreen.id,
        onSelected: (item) {
          currentScreen(item);
         // if (item.route != null) {
           // Navigator.of(context).pushNamed(item.route!);
       //   }
        },
       /* header: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'Top Care',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        footer: Container(
          height: 50,
          width: double.infinity,
          color: const Color(0xff444444),
          child: const Center(
            child: Text(
              'footer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),*/
      ),
      body: SingleChildScrollView(
        child: _selectedScreen,
      ),
    );
  }
}
