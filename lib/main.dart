import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:web_admin/screens/Admin_screen.dart';
import 'package:web_admin/screens/report_screen.dart';
import 'package:web_admin/screens/splash_screen.dart';
import 'package:web_admin/services/firebase_services.dart';
import 'screens/dashboard_screen.dart';
import 'screens/manage_categories.dart';
import 'screens/manage_services.dart';
import 'screens/requests_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'screens/users_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "APIKey",
        authDomain: "flutter-topcare.firebaseapp.com",
        projectId: "flutter-topcare",
        storageBucket: "flutter-topcare.appspot.com",
        messagingSenderId: "639592067343",
        appId: "apiID",
        measurementId: "G-MQE34741C2"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseServices _services = FirebaseServices();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        DashScreen.id: (context) => DashScreen(),
        RequestsScreen.id: (context) => RequestsScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        ServiceScreen.id: (context) => ServiceScreen(),
        UsersScreen.id: (context) => UsersScreen(),
        ReportScreen.id: (context) => ReportScreen(),
        AdminScreen.id: (context) => AdminScreen(),
      },
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
