import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'RLViray App';
  static const String appVersion = '1.0.0';

  // Database
  static const String databaseName = 'rlviray_app.db';
  static const int databaseVersion = 1;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy - hh:mm a';

  // Validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int minPasswordLength = 6;

  // UI
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;

  // Messages
  static const String noDataMessage = 'No data available';
  static const String errorMessage = 'Something went wrong';
  static const String successMessage = 'Operation successful';
}

class AppColors {
  // Primary Colors
  static const primaryBlue = Color(0xFF2196F3);
  static const primaryGreen = Color(0xFF4CAF50);
  static const primaryRed = Color(0xFFF44336);
  static const primaryOrange = Color(0xFFFF9800);

  // Neutral Colors
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey400 = Color(0xFFBDBDBD);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey600 = Color(0xFF757575);
  static const grey700 = Color(0xFF616161);
  static const grey800 = Color(0xFF424242);
  static const grey900 = Color(0xFF212121);
}
