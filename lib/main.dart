import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/manager_dashboard.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
  );

  runApp(RoomBookingApp());
}

class RoomBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Room Booking',
      theme: ThemeData(
  primaryColor: Colors.teal,
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
  ),
),
  routes: {
  "/home": (_) => HomeScreen(),
  "/login": (_) => LoginScreen(),
  "/manager": (_) => ManagerDashboard(),
},
      home: HomeScreen(),
      
    );
  }
}