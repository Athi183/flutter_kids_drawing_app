import 'package:flutter/material.dart';
import 'package:flutter_application_kids_drawing_app/presentation/home_screen.dart';

class ScreenSplash extends StatelessWidget {
  const ScreenSplash({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure navigation happens after build using a callback
    Future.delayed(const Duration(seconds: 6), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ScreenHome()),
      );
    });

    return Scaffold(
      body: Center(child: Image.asset('assets/drawing-2802_256.gif')),
    );
  }
}
