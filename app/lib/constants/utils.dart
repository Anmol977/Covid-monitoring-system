import 'package:flutter/material.dart';

import 'colors.dart';

inLineTextButtonTheme() {
  return TextButton.styleFrom(
    minimumSize: const Size(0, 0),
    backgroundColor: AppColors.transparent,
    primary: AppColors.primaryColor,
  );
}
