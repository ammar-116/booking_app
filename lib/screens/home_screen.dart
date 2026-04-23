import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import 'room_type_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? city;
  const HomeScreen({super.key, this.city});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.forestGreen,
            onPrimary: AppColors.warmWhite,
            surface: AppColors.warmWhite,
            onSurface: AppColors.inkBlack,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> pickEndDate() async {
    if (startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a start date first")),
      );
      return;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate!.add(const Duration(days: 1)),
      firstDate: startDate!.add(const Duration(days: 1)),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.forestGreen,
            onPrimary: AppColors.warmWhite,
            surface: AppColors.warmWhite,
            onSurface: AppColors.inkBlack,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  @override
  Widget build(BuildContext context) {
    final bool datesSelected = startDate != null && endDate != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(
          widget.city != null ? widget.city! : 'Find Your Stay',
          style: AppTextStyles.titleLarge,
        ),
        actions: [
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              // ✅ Show nothing while Firebase auth state is loading
              // Previously this showed "Login" during the loading state,
              // making it look like the user was logged out
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              final user = snapshot.data;
              if (user == null) {
                return TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    'Login',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.forestGreen,
                    ),
                  ),
                );
              } else {
                return TextButton(
                  onPressed: () => FirebaseAuth.instance.signOut(),
                  child: Text(
                    'Logout',
                    style: AppTextStyles.labelBold.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.city != null) ...[
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.forestGreen,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.city!,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            AppSectionHeader(
              title: 'Select Your Dates',
              subtitle: 'Choose check-in and check-out',
            ),
            const SizedBox(height: 24),
            _DatePickerTile(
              label: 'Check-in',
              date: startDate,
              icon: Icons.login_outlined,
              onTap: pickStartDate,
            ),
            const SizedBox(height: 12),
            _DatePickerTile(
              label: 'Check-out',
              date: endDate,
              icon: Icons.logout_outlined,
              onTap: pickEndDate,
            ),
            if (datesSelected) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: AppDecorations.infoBanner,
                child: Row(
                  children: [
                    const Icon(
                      Icons.nights_stay_outlined,
                      color: AppColors.forestGreen,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${endDate!.difference(startDate!).inDays} night${endDate!.difference(startDate!).inDays == 1 ? '' : 's'}",
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.forestGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${formatDate(startDate!)}  →  ${formatDate(endDate!)}",
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: datesSelected
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomTypeScreen(
                              startDate: startDate!,
                              endDate: endDate!,
                              city: widget.city,
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text("Search Rooms"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
          ],
        ),
      ),
    );
  }
}

class _DatePickerTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final VoidCallback onTap;

  const _DatePickerTile({
    required this.label,
    required this.date,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.warmWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: date != null
                ? AppColors.forestGreen.withOpacity(0.4)
                : AppColors.softGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.inkBlack.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: date != null ? AppColors.forestGreen : AppColors.warmGrey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 2),
                Text(
                  date != null
                      ? date!.toLocal().toString().split(' ')[0]
                      : 'Select date',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: date != null
                        ? AppColors.inkBlack
                        : AppColors.warmGrey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: AppColors.warmGrey, size: 20),
          ],
        ),
      ),
    );
  }
}
