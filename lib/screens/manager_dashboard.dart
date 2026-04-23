import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../services/room_service.dart';

class ManagerDashboard extends StatefulWidget {
  @override
  _ManagerDashboardState createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  final bookingService = BookingService();
  String _filter = "all"; // all, pending, confirmed, cancelled

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user?.email != "amaarnaruto@gmail.com") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
    }
  }

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  void _showApproveDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Approve Booking?', style: AppTextStyles.titleLarge),
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
                  const SizedBox(height: 4),
                  Text(
                    'Advance: Rs ${booking.advanceAmount?.toStringAsFixed(0) ?? 'N/A'}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await bookingService.approveBooking(booking.id!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Booking approved")),
                    );
                  },
                  child: const Text('Approve'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
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
                  const SizedBox(height: 4),
                  Text(
                    'User: ${booking.userId}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('Refund owed to guest:', style: AppTextStyles.labelBold),
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
                  child: const Text('Confirm Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove Booking?', style: AppTextStyles.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This will permanently remove the booking record. This cannot be undone.',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 14),
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
                    backgroundColor: AppColors.charcoal,
                  ),
                  onPressed: () async {
                    await bookingService.deleteBooking(booking.id!);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Booking removed permanently."),
                      ),
                    );
                  },
                  child: const Text('Remove'),
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.cream,
        appBar: AppBar(
          title: Text('Manager Dashboard', style: AppTextStyles.titleLarge),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_outlined, color: AppColors.error),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/home",
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: StreamBuilder<List<Booking>>(
          stream: bookingService.getBookings(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.forestGreen),
              );
            }

            final allBookings = snapshot.data!;

            // Stats
            final total = allBookings.length;
            final pending = allBookings
                .where((b) => b.status == "pending")
                .length;
            final confirmed = allBookings
                .where((b) => b.status == "confirmed")
                .length;
            final cancelled = allBookings
                .where((b) => b.status == "cancelled")
                .length;

            // Filter
            final bookings = _filter == "all"
                ? allBookings
                : allBookings.where((b) => b.status == _filter).toList();

            return Column(
              children: [
                // Stats bar
                Container(
                  color: AppColors.warmWhite,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      _StatBadge(
                        label: 'Total',
                        value: total,
                        color: AppColors.forestGreen,
                      ),
                      _StatBadge(
                        label: 'Pending',
                        value: pending,
                        color: AppColors.pending,
                      ),
                      _StatBadge(
                        label: 'Confirmed',
                        value: confirmed,
                        color: AppColors.success,
                      ),
                      _StatBadge(
                        label: 'Cancelled',
                        value: cancelled,
                        color: AppColors.error,
                      ),
                    ],
                  ),
                ),

                // Filter chips
                Container(
                  color: AppColors.warmWhite,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          selected: _filter == "all",
                          onTap: () => setState(() => _filter = "all"),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Pending',
                          selected: _filter == "pending",
                          onTap: () => setState(() => _filter = "pending"),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Confirmed',
                          selected: _filter == "confirmed",
                          onTap: () => setState(() => _filter = "confirmed"),
                        ),
                        const SizedBox(width: 8),
                        _FilterChip(
                          label: 'Cancelled',
                          selected: _filter == "cancelled",
                          onTap: () => setState(() => _filter = "cancelled"),
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(height: 1),

                // Booking list
                Expanded(
                  child: bookings.isEmpty
                      ? Center(
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
                                  Icons.inbox_outlined,
                                  size: 48,
                                  color: AppColors.forestGreen,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No ${_filter == "all" ? "" : _filter} bookings',
                                style: AppTextStyles.titleMedium,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];

                            final roomList = RoomService.getRooms();
                            final matchingRooms = roomList
                                .where((r) => r.id == booking.roomId)
                                .toList();
                            final roomLabel = matchingRooms.isNotEmpty
                                ? '${matchingRooms.first.type} Room · ${matchingRooms.first.city}'
                                : booking.roomId;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: AppDecorations.card,
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 44,
                                          height: 44,
                                          decoration: BoxDecoration(
                                            color: AppColors.lightSage,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                roomLabel,
                                                style:
                                                    AppTextStyles.titleMedium,
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                "ID: ${booking.roomId}",
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ),
                                        AppStatusChip(status: booking.status),
                                      ],
                                    ),
                                    const SizedBox(height: 14),
                                    const Divider(height: 1),
                                    const SizedBox(height: 12),

                                    // Details
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 13,
                                          color: AppColors.warmGrey,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "${formatDate(booking.startDate)} → ${formatDate(booking.endDate)}",
                                          style: AppTextStyles.bodyLarge,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.payments_outlined,
                                          size: 13,
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
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.local_offer_outlined,
                                            size: 13,
                                            color: AppColors.success,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "${booking.discountLabel} (${booking.discountPercent?.toStringAsFixed(0)}% off)",
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  color: AppColors.success,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    const SizedBox(height: 14),

                                    // Action buttons
                                    Row(
                                      children: [
                                        // Approve button
                                        if (!booking.isApproved &&
                                            booking.status == "pending") ...[
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _showApproveDialog(
                                                    context,
                                                    booking,
                                                  ),
                                              child: const Text('Approve'),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],

                                        // Approved indicator
                                        if (booking.isApproved &&
                                            booking.status == "confirmed") ...[
                                          Expanded(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.success
                                                    .withOpacity(0.08),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: AppColors.success
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Icon(
                                                    Icons.check_circle_outline,
                                                    color: AppColors.success,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    'Approved',
                                                    style: AppTextStyles
                                                        .labelBold
                                                        .copyWith(
                                                          color:
                                                              AppColors.success,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],

                                        // Cancel button
                                        if (booking.status != "cancelled")
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () =>
                                                  _showCancelDialog(
                                                    context,
                                                    booking,
                                                  ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.error,
                                                side: BorderSide(
                                                  color: AppColors.error
                                                      .withOpacity(0.4),
                                                ),
                                              ),
                                              child: const Text('Cancel'),
                                            ),
                                          ),

                                        // Remove button
                                        if (booking.status == "cancelled")
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () =>
                                                  _showDeleteDialog(
                                                    context,
                                                    booking,
                                                  ),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    AppColors.charcoal,
                                                side: BorderSide(
                                                  color: AppColors.softGrey,
                                                ),
                                              ),
                                              child: const Text('Remove'),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: AppTextStyles.displayMedium.copyWith(
              color: color,
              fontSize: 22,
            ),
          ),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.forestGreen : AppColors.cream,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.forestGreen : AppColors.softGrey,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelBold.copyWith(
            color: selected ? AppColors.warmWhite : AppColors.charcoal,
          ),
        ),
      ),
    );
  }
}
