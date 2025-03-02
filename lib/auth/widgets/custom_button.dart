import 'package:flutter/material.dart';
import 'package:studylink/constants/color_constants.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const CustomButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
