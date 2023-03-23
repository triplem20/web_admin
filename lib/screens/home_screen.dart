import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  _showAlertDialog(context,title, message)async {
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

            Navigator.of(context).pushNamed(LoginScreen.id);
          }, child: Text("Yes")),


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
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Top Care'),
        actions: [
          IconButton(onPressed: (){
            _showAlertDialog(context, "Log Out ", "Are You Sure ?");


          }, icon: Icon(Icons.logout)),
        ],
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategoryScreen.id,
            icon: Icons.category,
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
