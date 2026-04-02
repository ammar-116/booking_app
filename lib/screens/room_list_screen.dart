import 'package:flutter/material.dart';
import '../../services/room_service.dart';
import 'booking_screen.dart';

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

  bool isOverlapping(DateTime start1, DateTime end1, DateTime start2, DateTime end2) {
  return start1.isBefore(end2) && end1.isAfter(start2);
}

  @override
  Widget build(BuildContext context) {
    final rooms = RoomService.getRooms();
    final bookings = RoomService.getBookings();

    return Scaffold(
      appBar: AppBar(title: Text("Available Rooms")),
      body: Column(
        children: [
          SizedBox(height: 10),

          // 🔹 Show selected dates
          Text(
            "From ${formatDate(startDate)} to ${formatDate(endDate)}",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 10),

          // 🔹 Room list
          Expanded(
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                final room = rooms[index];
                String status = "available";

for (var booking in bookings) {
  if (booking.roomId == room.id) {
    if (isOverlapping(startDate, endDate, booking.startDate, booking.endDate)) {
      status = "partial";
    }
  }
}

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text("${room.type} Room"),
                    subtitle: Text("${room.city} • Rs ${room.price}"),

                    // 🔜 placeholder for availability label
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

                    trailing: ElevatedButton(
                      onPressed: () {
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BookingScreen(
      room: room,
      startDate: startDate,
      endDate: endDate,
    ),
  ),
).then((_) {
  (context as Element).markNeedsBuild(); // force rebuild
});
},
                      child: Text("Book"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}