import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/room.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../services/discount_service.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Room room;
  final DateTime startDate;
  final DateTime endDate;
  final Discount? discount;

  const BookingScreen({
    required this.room,
    required this.startDate,
    required this.endDate,
    this.discount,
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
        .where((b) => b.roomId == widget.room.id && b.status != "cancelled")
        .toList();
    setState(() => isLoading = false);
  }

  bool isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) =>
      s1.isBefore(e2) && e1.isAfter(s2);

  bool isFullyAvailable() {
    for (var b in roomBookings) {
      if (isOverlapping(
        widget.startDate,
        widget.endDate,
        b.startDate,
        b.endDate,
      ))
        return false;
    }
    return true;
  }

  List<String> getAvailableSlots() {
    List<List<DateTime>> intervals = [];
    for (var b in roomBookings) {
      if (isOverlapping(
        widget.startDate,
        widget.endDate,
        b.startDate,
        b.endDate,
      )) {
        DateTime s = b.startDate.isBefore(widget.startDate)
            ? widget.startDate
            : b.startDate;
        DateTime e = b.endDate.isAfter(widget.endDate)
            ? widget.endDate
            : b.endDate;
        intervals.add([s, e]);
      }
    }
    if (intervals.isEmpty) return [];

    intervals.sort((a, b) => a[0].compareTo(b[0]));
    List<List<DateTime>> merged = [intervals.first];
    for (var i = 1; i < intervals.length; i++) {
      final last = merged.last;
      final curr = intervals[i];
      if (!curr[0].isAfter(last[1])) {
        if (curr[1].isAfter(last[1])) last[1] = curr[1];
      } else {
        merged.add(curr);
      }
    }

    List<String> suggestions = [];
    DateTime cursor = widget.startDate;
    for (var block in merged) {
      if (cursor.isBefore(block[0])) {
        suggestions.add("${formatDate(cursor)} → ${formatDate(block[0])}");
      }
      cursor = block[1];
    }
    if (cursor.isBefore(widget.endDate)) {
      suggestions.add("${formatDate(cursor)} → ${formatDate(widget.endDate)}");
    }
    return suggestions;
  }

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  double get totalPrice => DiscountService.getTotalPrice(
    pricePerNight: widget.room.price,
    startDate: widget.startDate,
    endDate: widget.endDate,
    discountPercent: widget.discount?.percent ?? 0,
  );

  double get advanceAmount => DiscountService.getAdvanceAmount(totalPrice);

  int get nights => widget.endDate.difference(widget.startDate).inDays;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.forestGreen),
        ),
      );
    }

    final available = isFullyAvailable();
    final suggestions = getAvailableSlots();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Review Booking', style: AppTextStyles.titleLarge),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.inkBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Room summary card
            Container(
              decoration: AppDecorations.card,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.lightSage,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.bed_outlined,
                          color: AppColors.forestGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.room.type} Room',
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
                                Expanded(
                                  child: Text(
                                    widget.room.address,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Dates
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: AppColors.warmGrey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${formatDate(widget.startDate)}  →  ${formatDate(widget.endDate)}",
                        style: AppTextStyles.bodyLarge,
                      ),
                      const Spacer(),
                      AppBadge(label: '$nights nights'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pricing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price per night', style: AppTextStyles.bodyMedium),
                      Text(
                        'Rs ${widget.room.price.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                  if (widget.discount != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.discount!.label} (${widget.discount!.percent.toStringAsFixed(0)}% off)',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                        Text(
                          '- Rs ${(widget.room.price * nights * widget.discount!.percent / 100).toStringAsFixed(0)}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  const Divider(height: 1),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: AppTextStyles.titleMedium),
                      Text(
                        'Rs ${totalPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.forestGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Advance (20%)', style: AppTextStyles.bodyMedium),
                      Text(
                        'Rs ${advanceAmount.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.forestGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Availability status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: available
                  ? AppDecorations.infoBanner
                  : BoxDecoration(
                      color: AppColors.error.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.error.withOpacity(0.3),
                      ),
                    ),
              child: Row(
                children: [
                  Icon(
                    available
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    color: available ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      available
                          ? "Room is fully available for your selected dates"
                          : "Room is not fully available for selected dates",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: available ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Alternative slots
            if (!available && suggestions.isNotEmpty) ...[
              const SizedBox(height: 16),
              AppSectionHeader(
                title: 'Available Slots',
                subtitle: 'Alternative dates for this room',
              ),
              const SizedBox(height: 12),
              ...suggestions.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_right,
                        color: AppColors.forestGreen,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(s, style: AppTextStyles.bodyLarge),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: available
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              room: widget.room,
                              startDate: widget.startDate,
                              endDate: widget.endDate,
                              discount: widget.discount,
                            ),
                          ),
                        );
                      }
                    : null,
                child: Text(
                  available ? "Proceed to Payment" : "Change Dates to Continue",
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}
