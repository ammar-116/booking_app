import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../models/booking.dart';
import '../../services/room_service.dart';

class BookingScreen extends StatefulWidget {
  final Room room;
  final DateTime startDate;
  final DateTime endDate;

  BookingScreen({
    required this.room,
    required this.startDate,
    required this.endDate,
  });

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String selectedPayment = "cash";

  int getTotalDays() {
    return widget.endDate.difference(widget.startDate).inDays;
  }

  double getTotalPrice() {
    return getTotalDays() * widget.room.price;
  }

  double getAdvance() {
    return getTotalPrice() * 0.2;
  }

  String formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  bool isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) {
    return s1.isBefore(e2) && e1.isAfter(s2);
  }

  void confirmBooking() async {
  if (getTotalDays() <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Invalid date selection")),
    );
    return;
  }

  final existingBookings = RoomService.getBookings();

for (var booking in existingBookings) {
  if (booking.roomId == widget.room.id &&
      isOverlapping(widget.startDate, widget.endDate, booking.startDate, booking.endDate)) {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Room already booked for selected dates")),
    );
    return;
  }
}

  

  await Future.delayed(Duration(seconds: 1));

  // ✅ Save booking
  RoomService.addBooking(
    Booking(
      roomId: widget.room.id,
      startDate: widget.startDate,
      endDate: widget.endDate,
    ),
  );

  String status = selectedPayment == "cash" ? "pending" : "confirmed";

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Booking Successful"),
      content: Text(
        "Room: ${widget.room.type}\n"
        "Status: $status\n"
        "Advance Paid: Rs ${getAdvance().toStringAsFixed(0)}",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text("OK"),
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final totalDays = getTotalDays();

    

    return Scaffold(
      appBar: AppBar(title: Text("Confirm Booking")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${widget.room.type} Room",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            Text("City: ${widget.room.city}"),
            Text("Dates: ${formatDate(widget.startDate)} → ${formatDate(widget.endDate)}"),
            Text("Days: $totalDays"),

            SizedBox(height: 20),

            Divider(),

            SizedBox(height: 10),

            Text("Total Price: Rs ${getTotalPrice().toStringAsFixed(0)}"),
            Text("Advance (20%): Rs ${getAdvance().toStringAsFixed(0)}"),

            SizedBox(height: 20),

            Text("Select Payment Method",
                style: TextStyle(fontWeight: FontWeight.bold)),

            RadioListTile(
              title: Text("Cash on Arrival"),
              value: "cash",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() => selectedPayment = value.toString());
              },
            ),

            RadioListTile(
              title: Text("Bank Transfer"),
              value: "bank",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() => selectedPayment = value.toString());
              },
            ),

            RadioListTile(
              title: Text("Digital Wallet"),
              value: "wallet",
              groupValue: selectedPayment,
              onChanged: (value) {
                setState(() => selectedPayment = value.toString());
              },
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirmBooking,
                child: Text("Confirm Booking"),
              ),
            )
          ],
        ),
      ),
    );
  }
}