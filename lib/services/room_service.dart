import '../models/booking.dart';
import '../models/room.dart';

class RoomService {

  static List<Room> getRooms() {
    return [
      Room(id: "1", type: "Deluxe", city: "Islamabad", price: 12000),
      Room(id: "2", type: "Regular", city: "Lahore", price: 8000),
      Room(id: "3", type: "Deluxe", city: "Karachi", price: 15000),
    ];
  }

  static List<Booking> _bookings = [
    Booking(
      roomId: "1",
      startDate: DateTime(2026, 4, 10),
      endDate: DateTime(2026, 4, 15),
    ),
  ];

  static List<Booking> getBookings() {
    return _bookings;
  }

  static void addBooking(Booking booking) {
    _bookings.add(booking);
  }
}