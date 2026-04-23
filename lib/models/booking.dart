class Booking {
  final String? id;
  final String roomId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  String status; // pending, confirmed, cancelled
  String paymentType; // cash, bank
  bool isApproved;
  double? advanceAmount;
  bool advancePaid;
  String? discountLabel;
  double? discountPercent;

  Booking({
    this.id,
    required this.roomId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.paymentType,
    this.status = "pending",
    this.isApproved = false,
    this.advanceAmount,
    this.advancePaid = false,
    this.discountLabel,
    this.discountPercent,
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
      "advanceAmount": advanceAmount,
      "advancePaid": advancePaid,
      "discountLabel": discountLabel,
      "discountPercent": discountPercent,
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
      paymentType: map['paymentType'] ?? "cash",
      isApproved: map['isApproved'] ?? false,
      advanceAmount: (map['advanceAmount'] as num?)?.toDouble(),
      advancePaid: map['advancePaid'] ?? false,
      discountLabel: map['discountLabel'],
      discountPercent: (map['discountPercent'] as num?)?.toDouble(),
    );
  }
}
