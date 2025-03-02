import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.onTap});
  final String imagePath;
  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 25, left: 20),
        child: Row(
          children: [
            SvgPicture.asset(imagePath),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
