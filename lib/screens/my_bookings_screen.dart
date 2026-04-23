import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../services/room_service.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final bookingService = BookingService();

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  void showCancelDialog(BuildContext context, Booking booking) {
    final refund = bookingService.refundLabel(booking);
    final daysUntil = booking.startDate.difference(DateTime.now()).inDays;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Booking?', style: AppTextStyles.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.infoBanner,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room: ${booking.roomId}',
                    style: AppTextStyles.labelBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${formatDate(booking.startDate)} → ${formatDate(booking.endDate)}",
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Refund Policy', style: AppTextStyles.labelBold),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.warningBanner,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    daysUntil >= 3
                        ? Icons.check_circle_outline
                        : daysUntil == 2
                        ? Icons.warning_amber_outlined
                        : Icons.cancel_outlined,
                    color: daysUntil >= 3
                        ? AppColors.success
                        : daysUntil == 2
                        ? AppColors.warning
                        : AppColors.error,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      refund,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: daysUntil >= 3
                            ? AppColors.success
                            : daysUntil == 2
                            ? AppColors.warning
                            : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!booking.advancePaid) ...[
              const SizedBox(height: 10),
              Text(
                'No advance was paid — nothing to refund.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Keep'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  onPressed: () async {
                    await bookingService.cancelBooking(booking.id!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Booking cancelled. $refund")),
                    );
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.cream,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.forestGreen),
            ),
          );
        }

        final user = authSnapshot.data;

        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.cream,
            appBar: AppBar(
              title: Text('My Bookings', style: AppTextStyles.titleLarge),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.lightSage,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: AppColors.forestGreen,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Sign in to view your bookings',
                      style: AppTextStyles.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your booking history will appear here once you log in.',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, "/login"),
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.cream,
          appBar: AppBar(
            title: Text('My Bookings', style: AppTextStyles.titleLarge),
            actions: [
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Text(
                  'Logout',
                  style: AppTextStyles.labelBold.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          body: StreamBuilder<List<Booking>>(
            stream: bookingService.getUserBookings(user.uid),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.forestGreen,
                  ),
                );
              }
              final bookings = snapshot.data!;
              if (bookings.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: AppColors.lightSage,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.hotel_outlined,
                            size: 48,
                            color: AppColors.forestGreen,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No bookings yet',
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your bookings will appear here once you make a reservation.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              final sorted = [...bookings]
                ..sort((a, b) {
                  if (a.status == "cancelled" && b.status != "cancelled")
                    return 1;
                  if (a.status != "cancelled" && b.status == "cancelled")
                    return -1;
                  return b.startDate.compareTo(a.startDate);
                });

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: sorted.length,
                itemBuilder: (context, index) {
                  final booking = sorted[index];
                  final roomList = RoomService.getRooms();
                  final matchingRooms = roomList
                      .where((r) => r.id == booking.roomId)
                      .toList();
                  if (matchingRooms.isEmpty) return const SizedBox.shrink();
                  final room = matchingRooms.first;
                  final isCancellable =
                      booking.status != "cancelled" &&
                      booking.status != "confirmed" &&
                      booking.startDate.isAfter(DateTime.now());

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: AppDecorations.card,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  color: AppColors.lightSage,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.bed_outlined,
                                  color: AppColors.forestGreen,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${room.type} Room',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 13,
                                          color: AppColors.warmGrey,
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          room.city,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              AppStatusChip(status: booking.status),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Divider(height: 1),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: AppColors.warmGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${formatDate(booking.startDate)} → ${formatDate(booking.endDate)}",
                                style: AppTextStyles.bodyLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.payments_outlined,
                                size: 14,
                                color: AppColors.warmGrey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "${booking.paymentType == "bank" ? "Bank Transfer" : "Cash"} · Advance: Rs ${booking.advanceAmount?.toStringAsFixed(0) ?? 'N/A'}",
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                          if (booking.discountLabel != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_offer_outlined,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "${booking.discountLabel} (${booking.discountPercent?.toStringAsFixed(0)}% off)",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (booking.status == "pending") ...[
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.pending.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.pending.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.hourglass_empty_outlined,
                                    size: 14,
                                    color: AppColors.pending,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Awaiting manager approval',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.pending,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (isCancellable) ...[
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () =>
                                    showCancelDialog(context, booking),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: BorderSide(
                                    color: AppColors.error.withOpacity(0.5),
                                  ),
                                ),
                                child: const Text('Cancel Booking'),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
