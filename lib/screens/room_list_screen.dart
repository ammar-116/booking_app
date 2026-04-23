import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/room_service.dart';
import '../../services/booking_service.dart';
import '../../services/discount_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/booking.dart';
import 'room_detail_screen.dart';

class RoomListScreen extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String? city;
  final String? roomType;

  const RoomListScreen({
    required this.startDate,
    required this.endDate,
    this.city,
    this.roomType,
  });

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  bool isOverlapping(DateTime s1, DateTime e1, DateTime s2, DateTime e2) =>
      s1.isBefore(e2) && e1.isAfter(s2);

  @override
  Widget build(BuildContext context) {
    final allRooms = RoomService.getRooms();
    final rooms = allRooms.where((r) {
      final cityMatch = city == null || r.city == city;
      final typeMatch = roomType == null || r.type == roomType;
      return cityMatch && typeMatch;
    }).toList();

    final nights = endDate.difference(startDate).inDays;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          roomType != null ? '$roomType Rooms' : 'Available Rooms',
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
              // Date + nights banner
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
                    Text("($nights nights)", style: AppTextStyles.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              AppSectionHeader(
                title: roomType != null ? '$roomType Rooms' : 'All Rooms',
                subtitle: city != null
                    ? '$city • ${rooms.length} listings'
                    : '${rooms.length} listings',
              ),
              const SizedBox(height: 16),

              ...rooms.map((room) {
                // Availability logic
                String status = "available";
                bool hasOverlap = false;
                bool fullyBlocked = false;

                for (var b in bookings) {
                  if (b.roomId == room.id && b.status != "cancelled") {
                    if (isOverlapping(
                      startDate,
                      endDate,
                      b.startDate,
                      b.endDate,
                    )) {
                      hasOverlap = true;
                      if (!b.startDate.isAfter(startDate) &&
                          !b.endDate.isBefore(endDate)) {
                        fullyBlocked = true;
                      }
                    }
                  }
                }

                if (fullyBlocked) {
                  status = "unavailable";
                } else if (hasOverlap) {
                  status = "partial";
                }

                // Discount
                final discount = DiscountService.getBestDiscount(
                  room.type,
                  startDate,
                );
                final discountedPrice = discount != null
                    ? DiscountService.applyDiscount(
                        room.price,
                        discount.percent,
                      )
                    : room.price;
                final totalPrice = discountedPrice * nights;

                Color statusColor;
                IconData statusIcon;
                String statusLabel;
                switch (status) {
                  case "available":
                    statusColor = AppColors.success;
                    statusIcon = Icons.check_circle_outline;
                    statusLabel = "Available";
                    break;
                  case "partial":
                    statusColor = AppColors.warning;
                    statusIcon = Icons.warning_amber_outlined;
                    statusLabel = "Partial";
                    break;
                  default:
                    statusColor = AppColors.error;
                    statusIcon = Icons.cancel_outlined;
                    statusLabel = "Unavailable";
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: AppDecorations.card,
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // ← key fix
                    children: [
                      // Photo
                      SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: Image.asset(room.imageAsset, fit: BoxFit.cover),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // ← key fix
                          children: [
                            // Title
                            Text(
                              '${room.type} Room',
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: 4),

                            // Address
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
                                    room.address,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Description
                            Text(
                              room.description,
                              style: AppTextStyles.bodyMedium,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),

                            // Facilities
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: room.facilities
                                  .map(
                                    (f) => AppBadge(
                                      label: f,
                                      icon: _facilityIcon(f),
                                    ),
                                  )
                                  .toList(),
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1),
                            const SizedBox(height: 14),

                            // Price row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Pricing — left side
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (discount != null)
                                        Text(
                                          'Rs ${room.price.toStringAsFixed(0)}/night',
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontSize: 11,
                                              ),
                                        ),
                                      Text(
                                        'Rs ${discountedPrice.toStringAsFixed(0)}/night',
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              color: discount != null
                                                  ? AppColors.success
                                                  : AppColors.forestGreen,
                                            ),
                                      ),
                                      Text(
                                        'Total: Rs ${totalPrice.toStringAsFixed(0)}',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ),

                                // Status badge — right side
                                AppBadge(
                                  label: statusLabel,
                                  icon: statusIcon,
                                  color: statusColor.withOpacity(0.1),
                                  textColor: statusColor,
                                ),
                              ],
                            ),

                            // Discount badge
                            if (discount != null) ...[
                              const SizedBox(height: 10),
                              AppBadge(
                                label:
                                    '${discount.label} · ${discount.percent.toStringAsFixed(0)}% off',
                                icon: Icons.local_offer_outlined,
                                color: AppColors.success.withOpacity(0.1),
                                textColor: AppColors.success,
                              ),
                            ],
                            const SizedBox(height: 14),

                            // Book button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: status == "unavailable"
                                    ? null
                                    : () {
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        if (user == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please login to book a room",
                                              ),
                                            ),
                                          );
                                          Navigator.pushNamed(
                                            context,
                                            "/login",
                                          );
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RoomDetailScreen(
                                              room: room,
                                              startDate: startDate,
                                              endDate: endDate,
                                              discount: discount,
                                            ),
                                          ),
                                        );
                                      },
                                style: status == "unavailable"
                                    ? ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.softGrey,
                                        foregroundColor: AppColors.warmGrey,
                                      )
                                    : null,
                                child: Text(
                                  status == "unavailable"
                                      ? "Unavailable"
                                      : "View Room",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }

  IconData _facilityIcon(String facility) {
    switch (facility.toLowerCase()) {
      case "wifi":
        return Icons.wifi;
      case "ac":
        return Icons.ac_unit;
      case "heater":
        return Icons.local_fire_department_outlined;
      case "geyser":
        return Icons.hot_tub_outlined;
      case "tv":
        return Icons.tv_outlined;
      case "mini fridge":
        return Icons.kitchen_outlined;
      case "parking":
        return Icons.local_parking_outlined;
      case "room service":
        return Icons.room_service_outlined;
      case "balcony":
        return Icons.balcony_outlined;
      case "fireplace":
        return Icons.fireplace_outlined;
      case "terrace":
        return Icons.roofing_outlined;
      case "mountain view":
        return Icons.terrain_outlined;
      case "sea view":
        return Icons.water_outlined;
      case "river view":
        return Icons.water_outlined;
      case "garden view":
        return Icons.park_outlined;
      case "garden access":
        return Icons.park_outlined;
      case "rooftop access":
        return Icons.roofing_outlined;
      case "bathtub":
        return Icons.bathtub_outlined;
      case "veranda":
        return Icons.deck_outlined;
      case "shared bathroom":
        return Icons.wc_outlined;
      case "fan":
        return Icons.air_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }
}
