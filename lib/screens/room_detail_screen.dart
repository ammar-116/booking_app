import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/room.dart';
import '../../services/discount_service.dart';
import 'booking_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RoomDetailScreen extends StatelessWidget {
  final Room room;
  final DateTime startDate;
  final DateTime endDate;
  final Discount? discount;

  const RoomDetailScreen({
    required this.room,
    required this.startDate,
    required this.endDate,
    this.discount,
  });

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  int get nights => endDate.difference(startDate).inDays;

  double get totalPrice => DiscountService.getTotalPrice(
    pricePerNight: room.price,
    startDate: startDate,
    endDate: endDate,
    discountPercent: discount?.percent ?? 0,
  );

  double get advanceAmount => DiscountService.getAdvanceAmount(totalPrice);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Full photo app bar
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.forestGreen,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.inkBlack.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.warmWhite,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(room.imageAsset, fit: BoxFit.cover),
                  // Gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.inkBlack.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Room type badge
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: AppBadge(
                      label: room.type,
                      color: AppColors.forestGreen.withOpacity(0.9),
                      textColor: AppColors.warmWhite,
                    ),
                  ),
                  // Discount badge
                  if (discount != null)
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: AppBadge(
                        label:
                            '${discount!.label} · ${discount!.percent.toStringAsFixed(0)}% off',
                        icon: Icons.local_offer_outlined,
                        color: AppColors.success.withOpacity(0.9),
                        textColor: AppColors.warmWhite,
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + city
                  Text('${room.type} Room', style: AppTextStyles.displayMedium),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 15,
                        color: AppColors.warmGrey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          room.address,
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Dates + duration
                  const AppSectionHeader(title: 'Your Stay'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.infoBanner,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check-in', style: AppTextStyles.bodyMedium),
                              const SizedBox(height: 4),
                              Text(
                                formatDate(startDate),
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: AppColors.warmGrey,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$nights nights',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Check-out',
                                style: AppTextStyles.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatDate(endDate),
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Description
                  const AppSectionHeader(title: 'About This Room'),
                  const SizedBox(height: 12),
                  Text(room.description, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Facilities
                  const AppSectionHeader(title: 'Facilities'),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: room.facilities.map((f) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warmWhite,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _facilityIcon(f),
                              size: 13,
                              color: AppColors.forestGreen,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              f,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Divider(height: 1),
                  const SizedBox(height: 24),

                  // Pricing breakdown
                  const AppSectionHeader(title: 'Pricing'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.card,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price per night',
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              'Rs ${room.price.toStringAsFixed(0)}',
                              style: AppTextStyles.bodyLarge,
                            ),
                          ],
                        ),
                        if (discount != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${discount!.label} (${discount!.percent.toStringAsFixed(0)}% off)',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                              Text(
                                '- Rs ${(room.price * nights * discount!.percent / 100).toStringAsFixed(0)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total for $nights nights',
                              style: AppTextStyles.titleMedium,
                            ),
                            Text(
                              'Rs ${totalPrice.toStringAsFixed(0)}',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.forestGreen,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: AppDecorations.infoBanner,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Advance due (20%)',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.forestGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Rs ${advanceAmount.toStringAsFixed(0)}',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cancellation policy
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: AppDecorations.warningBanner,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.warning,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Cancellation Policy',
                              style: AppTextStyles.labelBold.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _PolicyRow(
                          icon: Icons.check_circle_outline,
                          color: AppColors.success,
                          text: '3+ days before check-in: 100% refund',
                        ),
                        const SizedBox(height: 6),
                        _PolicyRow(
                          icon: Icons.warning_amber_outlined,
                          color: AppColors.warning,
                          text: '2 days before check-in: 50% refund',
                        ),
                        const SizedBox(height: 6),
                        _PolicyRow(
                          icon: Icons.cancel_outlined,
                          color: AppColors.error,
                          text: '1 day or less: No refund',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Sticky bottom Book Now button
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          boxShadow: [
            BoxShadow(
              color: AppColors.inkBlack.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Price summary
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rs ${totalPrice.toStringAsFixed(0)}',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.forestGreen,
                    ),
                  ),
                  Text(
                    'for $nights nights · Rs ${advanceAmount.toStringAsFixed(0)} advance',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Book Now button
            ElevatedButton(
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please login to book a room"),
                    ),
                  );
                  Navigator.pushNamed(context, "/login");
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingScreen(
                      room: room,
                      startDate: startDate,
                      endDate: endDate,
                      discount: discount,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _PolicyRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 15),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
