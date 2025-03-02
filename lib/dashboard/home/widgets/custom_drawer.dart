import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studylink/auth/controllers/auth_controller.dart';
import 'package:studylink/dashboard/home/widgets/custom_row_widget.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthenticationProvider>(context, listen: false);
    return Drawer(
        child: Column(
      children: [
        CustomRowWidget(
            onTap: () {
              // Navigator.popAndPushNamed(context, Routes.profile);
            },
            imagePath: 'Paths.profileIconPath',
            title: 'StringConstants.myProfile'),
        CustomRowWidget(
            onTap: () {},
            imagePath: ' Paths.submittedQuizIcon',
            title: ' StringConstants.submittedQuiz'),
        CustomRowWidget(
            onTap: () {
              // Navigator.popAndPushNamed(context, Routes.notification);
            },
            imagePath: ' Paths.notificationIconPath',
            title: 'StringConstants.notification'),
        CustomRowWidget(
            onTap: () {
              // Navigator.popAndPushNamed(context, Routes.mycourse);
            },
            imagePath: ' Paths.educationIconPath',
            title: 'StringConstants.myCourses'),
        // CustomRowWidget(
        //     onTap: () {
        //       // Share.share('Please Download Our App....');
        //     },
        //     imagePath: Paths.shareIconPath,
        //     title: StringConstants.shareApp),
        CustomRowWidget(
            onTap: () {
              // Navigator.popAndPushNamed(context, Routes.privacyandpolicy);
            },
            imagePath: 'Paths.documentIconPath',
            title: ' StringConstants.privacyAndPolicy'),
        SizedBox(height: MediaQuery.of(context).size.height * 1 / 7),
        const Divider(thickness: .5),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 21, top: 8),
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.purple)),
              onPressed: () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                      content: const Text(
                        "Are you sure you want to Logout?",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      title: const Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40),
                              elevation: 0,
                              backgroundColor: Colors.transparent),
                          child: const Text(
                            'No',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 40),
                              backgroundColor: Colors.red),
                          child: const Text(
                            'Yes',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () async {
                            authController.signOut();
                          },
                        ),
                      ],
                    ),
                  ),
              // await LocalStorage().deleteAll();
              // authController.clearAll().then((value) =>
              //     Navigator.pushNamedAndRemoveUntil(
              //         context, Routes.login, (route) => false));

              // var customerBox =
              //     Hive.box<UserDetailsModel>('userDetails');
              // await customerBox.delete('user');
              // Navigate using the global key
              // ignore: use_build_context_synchronously
              // Navigator.pushNamedAndRemoveUntil(
              //     context, Routes.login, (route) => false);

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SvgPicture.asset(
                  //     // Paths.logoutIconPath,
                  //     ),
                  const SizedBox(width: 11.5),
                  const Text(
                    "Logout",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              )),
        )
      ],
    ));
  }
}
