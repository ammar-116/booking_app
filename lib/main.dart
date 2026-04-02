import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
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
      home: HomeScreen(),
    );
  }
}