import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'api.dart';
import 'colors.dart';

inLineTextButtonTheme() {
  return TextButton.styleFrom(
    minimumSize: const Size(0, 0),
    backgroundColor: AppColors.transparent,
    primary: AppColors.primaryColor,
  );
}

bool hasError(
  BuildContext context,
  Map<String, dynamic> response,
) {
  if (response[Api.error].isNotEmpty) {
    showErrorSnackBar(context, response[Api.error]);
    return true;
  } else {
    showSuccessSnackBar(context, response[Api.message]);
    return false;
  }
}

Color statusColor(String status) {
  return AppColors.tertiaryColor;
}

showSuccessSnackBar(BuildContext context, String successMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.successColor,
      content: Row(
        children: [
          const Icon(Icons.error),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              successMessage,
              style: const TextStyle(color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    ),
  );
}

showErrorSnackBar(BuildContext context, String errorMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.errorColor,
      content: Row(
        children: [
          const Icon(Icons.error),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              errorMessage,
              style: const TextStyle(color: AppColors.secondaryColor),
            ),
          ),
        ],
      ),
    ),
  );
}
