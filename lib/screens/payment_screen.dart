import 'package:flutter/material.dart';
import 'dart:math';
import '../../theme/app_theme.dart';
import '../../models/booking.dart';
import '../../models/room.dart';
import '../../services/booking_service.dart';
import '../../services/discount_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  final Room room;
  final DateTime startDate;
  final DateTime endDate;
  final Discount? discount;

  const PaymentScreen({
    required this.room,
    required this.startDate,
    required this.endDate,
    this.discount,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final bookingService = BookingService();
  String selectedPaymentType = "cash";
  bool isProcessing = false;

  final accountTitleController = TextEditingController();
  final accountNumberController = TextEditingController();

  @override
  void dispose() {
    accountTitleController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  double get totalPrice => DiscountService.getTotalPrice(
    pricePerNight: widget.room.price,
    startDate: widget.startDate,
    endDate: widget.endDate,
    discountPercent: widget.discount?.percent ?? 0,
  );

  double get advanceAmount => DiscountService.getAdvanceAmount(totalPrice);

  int get nights => widget.endDate.difference(widget.startDate).inDays;

  String formatDate(DateTime date) => date.toLocal().toString().split(' ')[0];

  String generateTransactionId() {
    final rand = Random();
    return "TXN-${100000 + rand.nextInt(900000)}";
  }

  void confirmPayment() async {
    // ✅ Check auth FIRST before doing anything
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Navigator.pushNamed(context, '/login');
      return;
    }

    if (selectedPaymentType == "bank") {
      if (accountTitleController.text.trim().isEmpty ||
          accountNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all bank details")),
        );
        return;
      }
    }

    setState(() => isProcessing = true);

    if (selectedPaymentType == "bank") {
      await Future.delayed(const Duration(seconds: 2));
    }

    final txnId = generateTransactionId();
    await bookingService.addBooking(
      Booking(
        roomId: widget.room.id,
        userId: user.uid, // ✅ user is guaranteed non-null here
        startDate: widget.startDate,
        endDate: widget.endDate,
        paymentType: selectedPaymentType,
        status: "pending",
        isApproved: false,
        advanceAmount: advanceAmount,
        advancePaid: true,
        discountLabel: widget.discount?.label,
        discountPercent: widget.discount?.percent,
      ),
    );

    // ... rest of the dialog code stays exactly the same

    setState(() => isProcessing = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.warmWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text('Booking Confirmed', style: AppTextStyles.titleLarge),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your booking request has been submitted.',
              style: AppTextStyles.bodyLarge,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: AppDecorations.infoBanner,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedPaymentType == "bank") ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_outlined,
                          size: 15,
                          color: AppColors.forestGreen,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          txnId,
                          style: AppTextStyles.labelBold.copyWith(
                            color: AppColors.forestGreen,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_outlined,
                        size: 15,
                        color: AppColors.forestGreen,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Advance paid: Rs ${advanceAmount.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 15,
                        color: AppColors.forestGreen,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          selectedPaymentType == "cash"
                              ? "Please pay the advance to the manager upon arrival."
                              : "Payment has been processed successfully.",
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Done"),
            ),
          ),
        ],
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Payment', style: AppTextStyles.titleLarge),
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
            // Booking summary
            AppSectionHeader(
              title: 'Booking Summary',
              subtitle: '${widget.room.type} Room · ${widget.room.city}',
            ),
            const SizedBox(height: 16),
            Container(
              decoration: AppDecorations.card,
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Check-in', style: AppTextStyles.bodyMedium),
                      Text(
                        formatDate(widget.startDate),
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Check-out', style: AppTextStyles.bodyMedium),
                      Text(
                        formatDate(widget.endDate),
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Duration', style: AppTextStyles.bodyMedium),
                      Text('$nights nights', style: AppTextStyles.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Price/night', style: AppTextStyles.bodyMedium),
                      Text(
                        'Rs ${widget.room.price.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyLarge,
                      ),
                    ],
                  ),
                  if (widget.discount != null) ...[
                    const SizedBox(height: 8),
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
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
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

            // Payment method
            const AppSectionHeader(title: 'Payment Method'),
            const SizedBox(height: 14),
            Row(
              children: [
                _PaymentOption(
                  label: 'Cash',
                  subtitle: 'Pay on arrival',
                  icon: Icons.money_outlined,
                  selected: selectedPaymentType == "cash",
                  onTap: () => setState(() => selectedPaymentType = "cash"),
                ),
                const SizedBox(width: 12),
                _PaymentOption(
                  label: 'Bank Transfer',
                  subtitle: 'Pay online now',
                  icon: Icons.account_balance_outlined,
                  selected: selectedPaymentType == "bank",
                  onTap: () => setState(() => selectedPaymentType = "bank"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bank details form
            if (selectedPaymentType == "bank") ...[
              const AppSectionHeader(title: 'Bank Details'),
              const SizedBox(height: 14),
              Text('Account Title', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: accountTitleController,
                style: AppTextStyles.bodyLarge,
                decoration: const InputDecoration(
                  hintText: 'e.g. Muhammad Ali',
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text('Account Number / IBAN', style: AppTextStyles.labelBold),
              const SizedBox(height: 8),
              TextField(
                controller: accountNumberController,
                style: AppTextStyles.bodyLarge,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'e.g. PK36SCBL0000001123456702',
                  prefixIcon: Icon(
                    Icons.credit_card_outlined,
                    color: AppColors.warmGrey,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],

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
                        size: 18,
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
            const SizedBox(height: 24),

            // Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isProcessing ? null : confirmPayment,
                child: isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.warmWhite,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: AppTextStyles.labelBold.copyWith(
                              color: AppColors.warmWhite,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Pay Rs ${advanceAmount.toStringAsFixed(0)} Advance',
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

class _PaymentOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.forestGreen.withOpacity(0.08)
                : AppColors.warmWhite,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.forestGreen : AppColors.softGrey,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.forestGreen : AppColors.warmGrey,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTextStyles.labelBold.copyWith(
                  color: selected ? AppColors.forestGreen : AppColors.charcoal,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
              ),
            ],
          ),
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
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}
