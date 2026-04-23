import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';

class MapScreen extends StatelessWidget {
  final void Function(String city)? onCityTap;

  MapScreen({super.key, this.onCityTap});

  final List<Map<String, dynamic>> cities = [
    {"name": "Islamabad", "x": 0.718, "y": 0.308},
    {"name": "Lahore", "x": 0.748, "y": 0.420},
    {"name": "Karachi", "x": 0.468, "y": 0.855},
    {"name": "Multan", "x": 0.638, "y": 0.500},
    {"name": "Peshawar", "x": 0.648, "y": 0.245},
    {"name": "Quetta", "x": 0.310, "y": 0.605},
    {"name": "Bahawalpur", "x": 0.690, "y": 0.545},
    {"name": "Murree", "x": 0.740, "y": 0.300},
    {"name": "Abbottabad", "x": 0.710, "y": 0.325},
    {"name": "Swat", "x": 0.660, "y": 0.220},
    {"name": "Skardu", "x": 0.835, "y": 0.188},
    {"name": "Gilgit", "x": 0.778, "y": 0.172},
    {"name": "Hunza", "x": 0.800, "y": 0.155},
    {"name": "Balakot", "x": 0.700, "y": 0.295},
    {"name": "Chilas", "x": 0.790, "y": 0.205},
    {"name": "Chitral", "x": 0.675, "y": 0.211},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.forestGreen,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 16,
                left: 24,
                right: 24,
                bottom: 24,
              ),
              child: Row(
                children: [
                  Image.asset('assets/logo.png', height: 58, width: 58),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('راہ سرائے', style: AppTextStyles.urduTitle),
                      Text(
                        'Dwellings Along The Path',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.sageGreen,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Map section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSectionHeader(
                    title: 'Choose Your City',
                    subtitle: 'Tap a pin to explore rooms',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: AppDecorations.cardElevated,
                    clipBehavior: Clip.antiAlias,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final mapWidth = constraints.maxWidth;
                        final mapHeight = mapWidth * (959 / 1000);
                        return SizedBox(
                          width: mapWidth,
                          height: mapHeight,
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                'assets/pk.svg',
                                width: mapWidth,
                                height: mapHeight,
                                fit: BoxFit.fill,
                              ),
                              ...cities.map((city) {
                                final x = city['x'] as double;
                                final y = city['y'] as double;
                                return Positioned(
                                  left: x * mapWidth - 36,
                                  top: y * mapHeight - 44,
                                  child: GestureDetector(
                                    onTap: () {
                                      // ✅ Switch tab in MainShell instead of
                                      // pushing a brand new route
                                      onCityTap?.call(city['name'] as String);
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.forestGreen,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.inkBlack
                                                    .withOpacity(0.2),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            city['name'],
                                            style: AppTextStyles.labelBold
                                                .copyWith(
                                                  color: AppColors.warmWhite,
                                                  fontSize: 9,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Icon(
                                          Icons.location_pin,
                                          color: AppColors.forestGreen,
                                          size: 20,
                                          shadows: [
                                            Shadow(
                                              color: AppColors.inkBlack
                                                  .withOpacity(0.2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // About Us section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSectionHeader(
                    title: 'About Raah-Sarae',
                    subtitle: 'Our story',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: AppDecorations.card,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.lightSage,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.home_work_outlined,
                                color: AppColors.forestGreen,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'A home wherever the road takes you',
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.forestGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Raah-Sarae was born from a simple belief that every traveller deserves a place to rest that feels like their own. Across Pakistan\'s cities, from the ancient streets of Peshawar to the sun-warmed shores of Karachi, we curate rooms that offer comfort, character, and care.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'We work with trusted hosts in 16 cities, offering over 42 carefully selected rooms, from budget-friendly to premium, so you always find the right dwelling along your path.',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _StatTile(
                              value: '16',
                              label: 'Cities',
                              icon: Icons.location_city_outlined,
                            ),
                            _StatDivider(),
                            _StatTile(
                              value: '42',
                              label: 'Rooms',
                              icon: Icons.bed_outlined,
                            ),
                            _StatDivider(),
                            _StatTile(
                              value: '3',
                              label: 'Types',
                              icon: Icons.hotel_outlined,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 16),
                        _ValueTile(
                          icon: Icons.verified_outlined,
                          title: 'Trusted Stays',
                          body:
                              'Every listing is verified for cleanliness, safety, and comfort before it appears on Raah-Sarae.',
                        ),
                        const SizedBox(height: 14),
                        _ValueTile(
                          icon: Icons.currency_rupee_outlined,
                          title: 'Fair Pricing',
                          body:
                              'Transparent pricing with seasonal discounts and no hidden charges. Book with confidence.',
                        ),
                        const SizedBox(height: 14),
                        _ValueTile(
                          icon: Icons.support_agent_outlined,
                          title: 'Dedicated Support',
                          body:
                              'Our team is always a message away, whether you need help booking or have questions during your stay.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _StatTile({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.forestGreen, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.forestGreen,
              fontSize: 20,
            ),
          ),
          Text(label, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: AppColors.divider);
  }
}

class _ValueTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _ValueTile({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.lightSage,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.forestGreen, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleMedium),
              const SizedBox(height: 2),
              Text(body, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
