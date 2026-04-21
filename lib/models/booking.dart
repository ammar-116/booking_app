class Booking {
  final String? id; // 🔥 Firestore document ID
  final String roomId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;

  String status;
  String paymentType;
  bool isApproved;

  Booking({
    this.id,
    required this.roomId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.paymentType,
    this.status = "pending",
    this.isApproved = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "userId": userId,
      "startDate": startDate,
      "endDate": endDate,
      "status": status,
      "paymentType": paymentType,
      "isApproved": isApproved,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String docId) {
    return Booking(
      id: docId,
      roomId: map['roomId'],
      userId: map['userId'],
      startDate: (map['startDate']).toDate(),
      endDate: (map['endDate']).toDate(),
      status: map['status'] ?? "pending",
      paymentType: map['paymentType'],
      isApproved: map['isApproved'] ?? false,
    );
  }
}