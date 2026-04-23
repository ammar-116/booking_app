// Discount types:

// Off-Season (Jan, Feb, Aug, Sep) → 15% — highest priority in slow months
// Last Minute Deal (within 3 days) → 10%
// Budget Pick (Regular rooms) → 8% — nudges users toward cheaper rooms
// Peak Season Deal (Deluxe in Jun, Jul, Dec) → 5% — keeps Deluxe competitive in busy months
// Mid-Week Deal (check-in Tue/Wed/Thu) → 7% — encourages off-peak check-ins

// Only the best discount applies — we calculate all applicable ones and pick the highest.

class Discount {
  final String label;
  final double percent;

  Discount({required this.label, required this.percent});
}

class DiscountService {
  // Returns the best applicable discount for a room + booking start date
  // Only one discount applies — the highest one
  static Discount? getBestDiscount(String roomType, DateTime startDate) {
    List<Discount> applicable = [];

    // ---------------------------
    // 1. OFF-SEASON DISCOUNT
    // Months: January, February, August, September
    // ---------------------------
    final month = startDate.month;
    if ([1, 2, 8, 9].contains(month)) {
      applicable.add(Discount(label: "Off-Season", percent: 15));
    }

    // ---------------------------
    // 2. LAST MINUTE DISCOUNT
    // Booking starts within 3 days from today
    // ---------------------------
    final daysUntilStart = startDate.difference(DateTime.now()).inDays;
    if (daysUntilStart <= 3 && daysUntilStart >= 0) {
      applicable.add(Discount(label: "Last Minute Deal", percent: 10));
    }

    // ---------------------------
    // 3. POPULARITY DISCOUNT
    // Regular rooms get a small push discount
    // ---------------------------
    if (roomType == "Regular") {
      applicable.add(Discount(label: "Budget Pick", percent: 8));
    }

    // ---------------------------
    // 4. PEAK SEASON SURCHARGE OFFSET
    // Deluxe rooms in peak months (Jun, Jul, Dec) get a small discount
    // to stay competitive
    // ---------------------------
    if (roomType == "Deluxe" && [6, 7, 12].contains(month)) {
      applicable.add(Discount(label: "Peak Season Deal", percent: 5));
    }

    // ---------------------------
    // 5. MID-WEEK DISCOUNT
    // Check-in on Tuesday, Wednesday, or Thursday
    // ---------------------------
    final weekday = startDate.weekday;
    if ([2, 3, 4].contains(weekday)) {
      applicable.add(Discount(label: "Mid-Week Deal", percent: 7));
    }

    if (applicable.isEmpty) return null;

    // Return only the best (highest) discount
    applicable.sort((a, b) => b.percent.compareTo(a.percent));
    return applicable.first;
  }

  // Apply discount to a price and return discounted price
  static double applyDiscount(double price, double discountPercent) {
    return price - (price * discountPercent / 100);
  }

  // Calculate total price with discount applied
  static double getTotalPrice({
    required double pricePerNight,
    required DateTime startDate,
    required DateTime endDate,
    required double discountPercent,
  }) {
    final nights = endDate.difference(startDate).inDays;
    final baseTotal = pricePerNight * nights;
    return applyDiscount(baseTotal, discountPercent);
  }

  // Calculate 20% advance from total
  static double getAdvanceAmount(double totalPrice) {
    return totalPrice * 0.20;
  }
}
