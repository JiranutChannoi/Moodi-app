import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/home_screen.dart';
import 'screens/account_screen.dart';
import 'screens/mood_tracking_screen.dart';
import 'screens/relaxation_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/mental_health_assessment_screen.dart';
import 'screens/journal_main_screen.dart'; // ✅ เพิ่มหน้านี้

void main() {
  runApp(const MoodiApp());
}

class MoodiApp extends StatelessWidget {
  const MoodiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moodi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        snackBarTheme: SnackBarThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: WelcomeScreen(),
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/mood': (context) => const MoodTrackingScreen(),
        '/relaxation': (context) => const RelaxationScreen(),
        '/ai-chat': (context) => const AIChatScreen(),
        '/mental-health': (context) => const MentalHealthAssessmentScreen(),
        '/journal': (context) => const JournalMainScreen(), // ✅ route ใหม่
      },
    );
  }
}
