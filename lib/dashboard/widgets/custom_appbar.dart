import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studylink/constants/color_constants.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const CustomAppbar({
    super.key,
    required this.title,
  });
  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        // actions: [
        //   Padding(
        //       padding: EdgeInsets.only(right: 12.0),
        //       child: SvgPicture.asset(
        //         "assets/icons/notification_icon.svg",
        //         height: 25,
        //         width: 25,
        //       )),
        // ],
        // leading: InkWell(
        //   onTap: (){},
        //   child: Icon(
        //     Icons.menu,
        //     color: Colors.black,
        //   ),
        // ),
        centerTitle: true,
        title: Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 18,
            color: ColorConstants.primaryColor,
            fontWeight: FontWeight.w800,
          ),
        ));
  }
}
