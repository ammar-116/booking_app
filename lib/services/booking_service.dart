import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking.dart';

class BookingService {
  final _db = FirebaseFirestore.instance;

  // Add a new booking
  Future<void> addBooking(Booking booking) async {
    await _db.collection("bookings").add(booking.toMap());
  }

  // Stream all bookings (for manager)
  Stream<List<Booking>> getBookings() {
    return _db.collection("bookings").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Stream bookings for a specific user (for MyBookingsScreen)
  Stream<List<Booking>> getUserBookings(String userId) {
    return _db
        .collection("bookings")
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Booking.fromMap(doc.data(), doc.id);
          }).toList();
        });
  }

  // One-time fetch (for BookingScreen overlap check)
  Future<List<Booking>> getBookingsOnce() async {
    final snapshot = await _db.collection("bookings").get();
    return snapshot.docs.map((doc) {
      return Booking.fromMap(doc.data(), doc.id);
    }).toList();
  }

  // Approve a booking (manager)
  Future<void> approveBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "isApproved": true,
      "status": "confirmed",
    });
  }

  // Cancel a booking (user)
  Future<void> cancelBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).update({
      "status": "cancelled",
      "isApproved": false,
    });
  }

  Future<void> deleteBooking(String bookingId) async {
    await _db.collection("bookings").doc(bookingId).delete();
  }

  // Calculate refund based on cancellation policy
  // 3+ days before start → 100% refund
  // 2 days before start  → 50% refund
  // 1 day or less        → no refund
  double calculateRefund(Booking booking) {
    if (booking.advanceAmount == null || !booking.advancePaid) return 0;

    final daysUntilStart = booking.startDate.difference(DateTime.now()).inDays;

    if (daysUntilStart >= 3) {
      return booking.advanceAmount!; // 100%
    } else if (daysUntilStart == 2) {
      return booking.advanceAmount! * 0.5; // 50%
    } else {
      return 0; // no refund
    }
  }

  // Refund label for display
  String refundLabel(Booking booking) {
    final daysUntilStart = booking.startDate.difference(DateTime.now()).inDays;

    if (daysUntilStart >= 3) {
      return "100% refund (Rs ${booking.advanceAmount?.toStringAsFixed(0)})";
    } else if (daysUntilStart == 2) {
      final amount = (booking.advanceAmount ?? 0) * 0.5;
      return "50% refund (Rs ${amount.toStringAsFixed(0)})";
    } else {
      return "No refund applicable";
    }
  }
}
