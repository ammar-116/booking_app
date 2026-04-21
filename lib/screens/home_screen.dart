import 'package:flutter/material.dart';
import 'room_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> pickEndDate() async {
    if (startDate == null) return;

    final picked = await showDatePicker(
      context: context,
      initialDate: startDate!.add(Duration(days: 1)),
      firstDate: startDate!.add(Duration(days: 1)),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text("Find Your Stay"),
  actions: [
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user == null) {
          // 🔐 NOT LOGGED IN
          return TextButton(
            onPressed: () {
              Navigator.pushNamed(context, "/login");
            },
            child: Text("Login", style: TextStyle(color: Colors.blue)),
          );
        } else {
          // 🔓 LOGGED IN
          return TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          );
        }
      },
    )
  ],
),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: pickStartDate,
              child: Text(
                startDate == null
                    ? "Select Start Date"
                    : "Start: ${startDate!.toLocal().toString().split(' ')[0]}",
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickEndDate,
              child: Text(
                endDate == null
                    ? "Select End Date"
                    : "End: ${endDate!.toLocal().toString().split(' ')[0]}",
              ),
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: (startDate != null && endDate != null)
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RoomListScreen(
                            startDate: startDate!,
                            endDate: endDate!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text("Search Rooms"),
            ),
          ],
        ),
      ),
    );
  }
}