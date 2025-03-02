import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color_constants.dart';

class CustomTextfield extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? fontStyle;
  final int? maxLines;
  final Function(String)? onChanged;
  final String? value;
  const CustomTextfield({
    super.key,
    this.label,
    required this.hint,
    this.value,
    this.controller,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.fontStyle,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label ?? '',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          onChanged: onChanged,
          controller: controller,
          style: fontStyle,
          decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.primaryColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
