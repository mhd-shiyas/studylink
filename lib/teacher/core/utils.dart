import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

class ValueLabel {
  final String? value;
  final String? label;

  ValueLabel({this.value, this.label});
}

class Utils {
  
  static List<ValueLabel> departments = [
    ValueLabel(
      label: "BCA",
      value: "BCA",
    ),
    ValueLabel(
      label: "BSC",
      value: "BSC",
    ),
    ValueLabel(
      label: "Bcom Computer Application",
      value: "Bcom Computer Application",
    ),
    ValueLabel(
      label: "Food Technology",
      value: "Food Technology",
    ),
  ];
 
}
