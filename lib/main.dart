import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studylink/auth/controllers/user_controller.dart';
import 'package:studylink/dashboard/home/controller/home_controller.dart';
import 'package:studylink/dashboard/notes/controller/notes_controller.dart';
import 'package:studylink/dashboard/semesters/controller/semester_controller.dart';
import 'package:studylink/dashboard/subject/controller/subject_controller.dart';
import 'package:studylink/firebase_options.dart';
import 'package:studylink/teacher/controllers/auth_controller.dart';
import 'package:studylink/teacher/controllers/home_controller.dart';

import 'auth/controllers/auth_controller.dart';
import 'splash/splash_screen.dart';
import 'teacher/controllers/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(
            create: (context) => TeachersAuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => UserController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => SemesterController()),
        ChangeNotifierProvider(create: (context) => SubjectController()),
        ChangeNotifierProvider(create: (context) => NotesController()),
        ChangeNotifierProvider(create: (context) => TeachersHomeController()),
        ChangeNotifierProvider(create: (context) => TeachersUserController()),
        ChangeNotifierProvider(
            create: (context) => TeachersAuthenticationProvider()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
