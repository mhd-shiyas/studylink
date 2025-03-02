import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Color? bgColor;
  final Color? textColor;
  final void Function()? onTap;
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.bgColor = ColorConstants.primaryColor,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
