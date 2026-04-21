import 'package:flutter/material.dart';
import '../../models/room.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final bookingService = BookingService();

  List<Booking> roomBookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final allBookings = await bookingService.getBookingsOnce();

    roomBookings = allBookings
        .where((b) => b.roomId == widget.room.id)
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  // ---------------------------
  // CORE OVERLAP CHECK
  // ---------------------------
  bool isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) {
    return s1.isBefore(e2) && e1.isAfter(s2);
  }

  bool isFullyAvailable() {
    for (var b in roomBookings) {
      if (isOverlapping(
        widget.startDate,
        widget.endDate,
        b.startDate,
        b.endDate,
      )) {
        return false;
      }
    }
    return true;
  }

  // ---------------------------
  // FIND AVAILABLE SUB-RANGES
  // ---------------------------
  List<String> getAvailableSlots() {
    List<DateTime> blockedDates = [];

    for (var b in roomBookings) {
      if (isOverlapping(
        widget.startDate,
        widget.endDate,
        b.startDate,
        b.endDate,
      )) {
        blockedDates.add(b.startDate);
        blockedDates.add(b.endDate);
      }
    }

    blockedDates.sort();

    List<String> suggestions = [];

    DateTime current = widget.startDate;

    for (var i = 0; i < blockedDates.length; i += 2) {
      DateTime blockStart = blockedDates[i];
      DateTime blockEnd = blockedDates[i + 1];

      if (current.isBefore(blockStart)) {
        suggestions.add(
          "${current.toString().split(' ')[0]} → ${blockStart.toString().split(' ')[0]}",
        );
      }

      current = blockEnd;
    }

    if (current.isBefore(widget.endDate)) {
      suggestions.add(
        "${current.toString().split(' ')[0]} → ${widget.endDate.toString().split(' ')[0]}",
      );
    }

    return suggestions;
  }

  String formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  double getTotalPrice() {
    return widget.endDate.difference(widget.startDate).inDays *
        widget.room.price;
  }

  @override
  Widget build(BuildContext context) {
    final available = isFullyAvailable();
    final suggestions = getAvailableSlots();

    return Scaffold(
      appBar: AppBar(title: Text("Booking Check")),

      body: isLoading
          ? Center(child: CircularProgressIndicator())

          : Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.room.type} Room",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Requested: ${formatDate(widget.startDate)} → ${formatDate(widget.endDate)}",
                  ),

                  SizedBox(height: 20),

                  Divider(),

                  SizedBox(height: 10),

                  // ---------------------------
                  // STATUS SECTION
                  // ---------------------------
                  if (available)
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.green.shade100,
                      child: Text(
                        "✅ Room is fully available for selected dates",
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.all(12),
                      color: Colors.red.shade100,
                      child: Text(
                        "❌ Room is NOT fully available for selected dates",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),

                  SizedBox(height: 20),

                  // ---------------------------
                  // SUGGESTIONS
                  // ---------------------------
                  if (!available) ...[
                    Text(
                      "Available alternative slots:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),

                    ...suggestions.map(
                      (s) => Text("• $s"),
                    ),
                  ],

                  Spacer(),

                  // ---------------------------
                  // BOOKING BUTTON BLOCKED IF NOT AVAILABLE
                  // ---------------------------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: available
                          ? () {
                              final user =
                                  FirebaseAuth.instance.currentUser;

                              if (user == null) {
                                Navigator.pushNamed(context, "/login");
                                return;
                              }

                              bookingService.addBooking(
                                Booking(
                                  roomId: widget.room.id,
                                  userId: user.uid,
                                  startDate: widget.startDate,
                                  endDate: widget.endDate,
                                  paymentType: "pending",
                                  status: "pending",
                                  isApproved: false,
                                ),
                              );

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text("Booking Created"),
                                  content: Text(
                                    "Your booking request has been submitted.",
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Text(
                        available
                            ? "Confirm Booking"
                            : "Change Dates to Continue",
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}