import 'package:flutter/material.dart';
import '../../services/room_service.dart';
import '../../models/booking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import  '../../services/booking_service.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {

  List<Booking> bookings = [];

  final bookingService = BookingService();

  @override
void initState() {
  super.initState();


  final user = FirebaseAuth.instance.currentUser;

  if (user?.email != "amaarnaruto@gmail.com") {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  bookings = RoomService.getBookings();
}

  void approveBooking(Booking booking) {
    setState(() {
      booking.isApproved = true;
      booking.status = "confirmed";
    });
  }

  String formatDate(DateTime date) {
    return date.toLocal().toString().split(' ')[0];
  }

  Color getStatusColor(String status) {
  if (status == "confirmed") return Colors.green;
  if (status == "pending") return Colors.orange;
  return Colors.grey;
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
  onWillPop: () async => false, // 🚫 disables back button completely
  child: Scaffold(
    appBar: AppBar(
      title: Text("Manager Dashboard"),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();

            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              (route) => false,
            );
          },
        )
      ],
    ),
    body: StreamBuilder<List<Booking>>(
  stream: bookingService.getBookings(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) {
      return Center(child: CircularProgressIndicator());
    }

    final bookings = snapshot.data!;

    return ListView.builder(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];

        return Card(
          margin: EdgeInsets.all(10),
          child: ListTile(
            title: Text("Room ${booking.roomId}"),
            subtitle: Text(
              "${formatDate(booking.startDate)} → ${formatDate(booking.endDate)}\n"
              "Payment: ${booking.paymentType}\n"
              "Status: ${booking.status}",
              style: TextStyle(
                color: getStatusColor(booking.status),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: (!booking.isApproved && booking.paymentType == "cash")
    ? ElevatedButton(
        onPressed: () async {
          await bookingService.approveBooking(booking.id!);
        },
        child: Text("Approve"),
      )
    : Icon(Icons.check, color: Colors.green),
          ),
        );
      },
    );
  },
)
  ),
);
  }
}