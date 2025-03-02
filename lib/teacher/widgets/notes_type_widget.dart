import 'package:flutter/material.dart';

import '../../constants/color_constants.dart';

class NotesTypeWidget extends StatelessWidget {
  final String title;
  final bool? value;
  final Function(bool?)? onChanged;
  const NotesTypeWidget({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            activeColor: ColorConstants.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: value,
            onChanged: onChanged),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
