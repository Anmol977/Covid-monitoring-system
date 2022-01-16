import 'package:covmon/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundColor,
    brightness: Brightness.dark,
    inputDecorationTheme: inputDecorationTheme(),
    appBarTheme: appBarTheme(),
    textButtonTheme: textButtonTheme(),
    elevatedButtonTheme: elevatedButtonTheme(),
    fontFamily: Strings.fontFamily,
  );
}

elevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: Size(8.sw, 50.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
    ),
  );
}

textButtonTheme() {
  return TextButtonThemeData(
    style: TextButton.styleFrom(
      minimumSize: Size(8.sw, 50.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      primary: AppColors.secondaryColor,
      backgroundColor: AppColors.primaryColor,
    ),
  );
}

appBarTheme() {
  return const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    elevation: 3,
    iconTheme: IconThemeData(color: AppColors.primaryColor),
  );
}

inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: const BorderSide(color: AppColors.primaryColor),
    gapPadding: 8.w,
  );
  OutlineInputBorder focusedInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30.r),
    borderSide: const BorderSide(color: AppColors.secondaryColor),
    gapPadding: 8.w,
  );

  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42.w, vertical: 20.h),
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedInputBorder,
    border: outlineInputBorder,
  );
}
