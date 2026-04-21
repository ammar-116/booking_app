import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  final _db = FirebaseFirestore.instance;

  Future<void> addBooking(Booking booking) async {
    await _db.collection("bookings").add(booking.toMap());
  }

  Stream<List<Booking>> getBookings() {
  return _db.collection("bookings").snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Booking.fromMap(doc.data(), doc.id); // 🔥 include doc.id
    }).toList();
  });
}

Future<List<Booking>> getBookingsOnce() async {
  final snapshot = await _db.collection("bookings").get();

  return snapshot.docs.map((doc) {
    return Booking.fromMap(doc.data(), doc.id);
  }).toList();
}

Future<void> approveBooking(String bookingId) async {
  await _db.collection("bookings").doc(bookingId).update({
    "isApproved": true,
    "status": "confirmed",
  });
}
}