// lib/theme/app_theme.dart

import 'package:flutter/material.dart';

class AppColors {
  // From logo
  static const forestGreen = Color(0xFF2D5A3D);
  static const sageGreen = Color(0xFF6F9C76);
  static const lightSage = Color(0xFFE8F0EA);
  static const cream = Color(0xFFF7F4EF);
  static const warmWhite = Color(0xFFFAF8F5);

  // Neutrals
  static const inkBlack = Color(0xFF1A1A1A);
  static const charcoal = Color(0xFF3D3D3D);
  static const warmGrey = Color(0xFF8A8A8A);
  static const softGrey = Color(0xFFD8D4CE);
  static const divider = Color(0xFFEAE6E0);

  // Status
  static const success = Color(0xFF3A7D52);
  static const warning = Color(0xFFB87333);
  static const error = Color(0xFFC0392B);
  static const pending = Color(0xFFD4892A);
}

class AppTextStyles {
  static const _base = TextStyle(
    fontFamily: 'Georgia',
    color: AppColors.inkBlack,
  );

  static final displayLarge = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static final displayMedium = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  static final titleLarge = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static final titleMedium = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final bodyLarge = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.charcoal,
  );

  static final bodyMedium = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.warmGrey,
  );

  static final labelBold = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );

  static final urduTitle = TextStyle(
    fontFamily: 'NotoNastaliqUrdu',
    fontSize: 20,
    color: AppColors.warmWhite,
    height: 1.8,
  );
}

class AppDecorations {
  static BoxDecoration card = BoxDecoration(
    color: AppColors.warmWhite,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.inkBlack.withOpacity(0.06),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration cardElevated = BoxDecoration(
    color: AppColors.warmWhite,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: AppColors.inkBlack.withOpacity(0.10),
        blurRadius: 20,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration greenBadge = BoxDecoration(
    color: AppColors.lightSage,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.sageGreen.withOpacity(0.4)),
  );

  static BoxDecoration infoBanner = BoxDecoration(
    color: AppColors.lightSage,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.sageGreen.withOpacity(0.3)),
  );

  static BoxDecoration warningBanner = BoxDecoration(
    color: const Color(0xFFFDF3E3),
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: AppColors.warning.withOpacity(0.3)),
  );
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: AppColors.cream,
    primaryColor: AppColors.forestGreen,
    colorScheme: ColorScheme.light(
      primary: AppColors.forestGreen,
      secondary: AppColors.sageGreen,
      background: AppColors.cream,
      surface: AppColors.warmWhite,
      error: AppColors.error,
      onPrimary: AppColors.warmWhite,
      onSecondary: AppColors.warmWhite,
      onBackground: AppColors.inkBlack,
      onSurface: AppColors.inkBlack,
    ),
    fontFamily: 'Georgia',
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.warmWhite,
      foregroundColor: AppColors.inkBlack,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: AppTextStyles.titleLarge,
      iconTheme: const IconThemeData(color: AppColors.forestGreen),
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.inkBlack.withOpacity(0.06),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.warmWhite,
      selectedItemColor: AppColors.forestGreen,
      unselectedItemColor: AppColors.warmGrey,
      selectedLabelStyle: AppTextStyles.labelBold.copyWith(
        color: AppColors.forestGreen,
      ),
      unselectedLabelStyle: AppTextStyles.labelBold.copyWith(
        color: AppColors.warmGrey,
      ),
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.forestGreen,
        foregroundColor: AppColors.warmWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelBold.copyWith(
          fontSize: 14,
          color: AppColors.warmWhite,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.forestGreen,
        side: const BorderSide(color: AppColors.forestGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: AppTextStyles.labelBold.copyWith(
          fontSize: 14,
          color: AppColors.forestGreen,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.forestGreen,
        textStyle: AppTextStyles.labelBold.copyWith(
          fontSize: 14,
          color: AppColors.forestGreen,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.warmWhite,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.softGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.softGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.forestGreen, width: 1.5),
      ),
      labelStyle: AppTextStyles.bodyMedium,
      hintStyle: AppTextStyles.bodyMedium,
    ),
    cardTheme: CardThemeData(
      color: AppColors.warmWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.warmWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: AppTextStyles.titleLarge,
      contentTextStyle: AppTextStyles.bodyLarge,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.charcoal,
      contentTextStyle: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.warmWhite,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

// Reusable widgets
class AppBadge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;
  final IconData? icon;

  const AppBadge({required this.label, this.color, this.textColor, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? AppColors.lightSage,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (textColor ?? AppColors.forestGreen).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor ?? AppColors.forestGreen),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelBold.copyWith(
              color: textColor ?? AppColors.forestGreen,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class AppStatusChip extends StatelessWidget {
  final String status;

  const AppStatusChip({required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.pending;
    }
  }

  IconData get _icon {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _color),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: AppTextStyles.labelBold.copyWith(
              color: _color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const AppSectionHeader({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.bodyMedium),
        ],
      ],
    );
  }
}
