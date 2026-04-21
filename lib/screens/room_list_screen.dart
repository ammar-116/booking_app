import 'package:flutter/material.dart';
import '../../services/room_service.dart';
import '../../services/booking_service.dart';
import 'booking_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/booking.dart';

class RoomListScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  RoomListScreen({
    required this.startDate,
    required this.endDate,
  });

  String formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  bool isOverlapping(
    DateTime start1,
    DateTime end1,
    DateTime start2,
    DateTime end2,
  ) {
    return start1.isBefore(end2) && end1.isAfter(start2);
  }

  @override
  Widget build(BuildContext context) {
    final rooms = RoomService.getRooms();

    return Scaffold(
      appBar: AppBar(title: Text("Available Rooms")),

      body: StreamBuilder<List<Booking>>(
        stream: BookingService().getBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!;

          return Column(
            children: [
              SizedBox(height: 10),

              // 📅 Selected dates
              Text(
                "From ${formatDate(startDate)} to ${formatDate(endDate)}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),

              // 🏨 Room list
              Expanded(
                child: ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    final room = rooms[index];

                    // -----------------------------
                    // 🔍 AVAILABILITY LOGIC (REAL DATA)
                    // -----------------------------
                    String status = "available";
                    bool hasOverlap = false;
                    bool fullyBlocked = false;

                    for (var booking in bookings) {
                      if (booking.roomId == room.id) {
                        if (isOverlapping(
                          startDate,
                          endDate,
                          booking.startDate,
                          booking.endDate,
                        )) {
                          hasOverlap = true;

                          // full block case
                          if (startDate.isAfter(booking.startDate) &&
                              endDate.isBefore(booking.endDate)) {
                            fullyBlocked = true;
                          }
                        }
                      }
                    }

                    if (fullyBlocked) {
                      status = "unavailable";
                    } else if (hasOverlap) {
                      status = "partial";
                    }

                    // -----------------------------
                    // 🧱 UI
                    // -----------------------------
                    return Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text("${room.type} Room"),

                        subtitle: Text(
                          "${room.city} • Rs ${room.price}",
                        ),

                        // 🎯 Status icon
                        leading: Icon(
                          status == "available"
                              ? Icons.check_circle
                              : status == "partial"
                                  ? Icons.warning
                                  : Icons.cancel,
                          color: status == "available"
                              ? Colors.green
                              : status == "partial"
                                  ? Colors.orange
                                  : Colors.red,
                        ),

                        // 🚫 Booking button
                        trailing: ElevatedButton(
                          onPressed: status == "unavailable"
                              ? null
                              : () {
                                  final user =
                                      FirebaseAuth.instance.currentUser;

                                  if (user == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please login to book a room",
                                        ),
                                      ),
                                    );

                                    Navigator.pushNamed(context, "/login");
                                    return;
                                  }

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingScreen(
                                        room: room,
                                        startDate: startDate,
                                        endDate: endDate,
                                      ),
                                    ),
                                  );
                                },
                          child: Text(
                            status == "unavailable"
                                ? "Unavailable"
                                : "Book",
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}