import 'package:flutter/material.dart';

class AppTheme {
  // Màu chủ đạo
  static const Color primaryColor = Color(0xFF3B4477);

  // Màu nút bấm
  static const Color buttonColor = Color(0xFFC99E4C);

  // Màu tiêu đề
  static const Color titleColor =
      Color(0xFFFFBD43); // Màu vàng cho tiêu đề EZNECT

  // Màu phụ
  static const Color secondaryColor = Color(0xFF4285F4);

  // Các biến thể của màu chính
  static const Color primaryLightColor = Color(0xFF5D6699);
  static const Color primaryDarkColor = Color(0xFF1A2257);

  // Màu văn bản
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Color(0xFFE0E0E0);
  static const Color textDarkColor = Color(0xFF333333);

  // Màu nền
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;

  // Màu trạng thái
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);

  // Màu biểu tượng
  static const Color iconActiveColor = Colors.white;
  static const Color iconInactiveColor = Color(0xB3FFFFFF); // white70

  // Các style text phổ biến
  static const TextStyle headingStyle = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: textDarkColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18.0,
    color: textDarkColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16.0,
    color: textDarkColor,
  );

  // Theme data cho toàn bộ ứng dụng
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primaryColor,
        selectedItemColor: iconActiveColor,
        unselectedItemColor: iconInactiveColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor, // Thay đổi màu nút thành C99E4C
          foregroundColor: textPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: headingStyle,
        titleLarge: subheadingStyle,
        bodyLarge: bodyTextStyle,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
      ),
    );
  }
}
