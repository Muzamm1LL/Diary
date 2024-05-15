import 'dart:async';
import 'package:diaryapp/extentions.dart';
import 'package:diaryapp/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToNextScreen(context);
  }

  Future<void> navigateToNextScreen(BuildContext context) async {
    // Simulate a delay for the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Navigate to the next screen (replace with your desired screen)
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginDemo()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'FBF7F7'.toColor(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                'assets/images/logo.png', // Replace with your image path
                width: 500,
                height: 500),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
