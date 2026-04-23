import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../services/booking_service.dart';
import '../../services/discount_service.dart';
import '../../services/room_service.dart';
import 'room_list_screen.dart';

class RoomTypeScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String? city;

  const RoomTypeScreen({
    required this.startDate,
    required this.endDate,
    this.city,
  });

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  bool isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) =>
      s1.isBefore(e2) && e1.isAfter(s2);

  @override
  Widget build(BuildContext context) {
    final allRooms = RoomService.getRooms();
    final cityRooms = city != null
        ? allRooms.where((r) => r.city == city).toList()
        : allRooms;

    final types = ["Deluxe", "Standard", "Regular"];

    final typeDescriptions = {
      "Deluxe": "Spacious premium room with full amenities and stunning views.",
      "Standard":
          "Comfortable room with essential amenities for a relaxing stay.",
      "Regular": "Affordable and cozy room, perfect for budget travellers.",
    };

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          city != null ? 'Rooms in $city' : 'Select Room Type',
          style: AppTextStyles.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: AppColors.inkBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<Booking>>(
        stream: BookingService().getBookings(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.forestGreen),
            );
          }

          final bookings = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Date banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: AppDecorations.infoBanner,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: AppColors.forestGreen,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${formatDate(startDate)}  →  ${formatDate(endDate)}",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "(${endDate.difference(startDate).inDays} nights)",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppSectionHeader(
                title: 'Choose a Room Type',
                subtitle: city != null
                    ? 'Available in $city'
                    : 'Across all cities',
              ),
              const SizedBox(height: 16),

              // Type cards
              ...types.map((type) {
                final typeRooms = cityRooms
                    .where((r) => r.type == type)
                    .toList();

                if (typeRooms.isEmpty) return const SizedBox.shrink();

                // Count available
                int availableCount = 0;
                for (var room in typeRooms) {
                  bool blocked = false;
                  for (var b in bookings) {
                    if (b.roomId == room.id &&
                        b.status != "cancelled" &&
                        isOverlapping(
                          startDate,
                          endDate,
                          b.startDate,
                          b.endDate,
                        )) {
                      if (!b.startDate.isAfter(startDate) &&
                          !b.endDate.isBefore(endDate)) {
                        blocked = true;
                        break;
                      }
                    }
                  }
                  if (!blocked) availableCount++;
                }

                // Price range
                final prices = typeRooms.map((r) => r.price).toList()..sort();
                final minPrice = prices.first;
                final priceLabel = prices.first == prices.last
                    ? "Rs ${prices.first.toStringAsFixed(0)}"
                    : "Rs ${prices.first.toStringAsFixed(0)} – ${prices.last.toStringAsFixed(0)}";

                // Discount
                final discount = DiscountService.getBestDiscount(
                  type,
                  startDate,
                );
                final discountedMin = discount != null
                    ? DiscountService.applyDiscount(minPrice, discount.percent)
                    : minPrice;

                final isUnavailable = availableCount == 0;

                return GestureDetector(
                  onTap: isUnavailable
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomListScreen(
                                startDate: startDate,
                                endDate: endDate,
                                city: city,
                                roomType: type,
                              ),
                            ),
                          );
                        },
                  child: Opacity(
                    opacity: isUnavailable ? 0.45 : 1.0,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: AppDecorations.card,
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Photo with availability badge overlay
                          Stack(
                            children: [
                              Image.asset(
                                type == "Deluxe"
                                    ? "assets/deluxe.jpg"
                                    : type == "Standard"
                                    ? "assets/std.jpeg"
                                    : "assets/reg.jpg",
                                width: double.infinity,
                                height: 140,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: AppBadge(
                                  label: isUnavailable
                                      ? 'Unavailable'
                                      : '$availableCount available',
                                  color: isUnavailable
                                      ? AppColors.error.withOpacity(0.85)
                                      : AppColors.forestGreen.withOpacity(0.85),
                                  textColor: AppColors.warmWhite,
                                ),
                              ),
                            ],
                          ),

                          // Info section
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  '$type Room',
                                  style: AppTextStyles.titleMedium,
                                ),
                                const SizedBox(height: 4),

                                // Description
                                Text(
                                  typeDescriptions[type]!,
                                  style: AppTextStyles.bodyMedium,
                                ),
                                const SizedBox(height: 12),

                                // Price + discount row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (discount != null)
                                          Text(
                                            '$priceLabel/night',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 11,
                                                ),
                                          ),
                                        Text(
                                          discount != null
                                              ? 'Rs ${discountedMin.toStringAsFixed(0)}/night'
                                              : '$priceLabel/night',
                                          style: AppTextStyles.titleMedium
                                              .copyWith(
                                                color: discount != null
                                                    ? AppColors.success
                                                    : AppColors.forestGreen,
                                              ),
                                        ),
                                      ],
                                    ),
                                    if (discount != null)
                                      AppBadge(
                                        label:
                                            '${discount.label} · ${discount.percent.toStringAsFixed(0)}% off',
                                        icon: Icons.local_offer_outlined,
                                        color: AppColors.success.withOpacity(
                                          0.1,
                                        ),
                                        textColor: AppColors.success,
                                      ),
                                  ],
                                ),

                                // View rooms hint
                                if (!isUnavailable) ...[
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'View rooms',
                                        style: AppTextStyles.labelBold.copyWith(
                                          color: AppColors.forestGreen,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 14,
                                        color: AppColors.forestGreen,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
