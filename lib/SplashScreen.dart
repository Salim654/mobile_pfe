import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:mobile_pfe/Views/LoginPage.dart';
import 'package:mobile_pfe/Views/HomePage.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/menuimg.png',
        ),
        nextScreen: _navigateBasedOnToken(context),
        splashTransition: SplashTransition.rotationTransition,
        duration: 3000,
      ),
    );
  }

  Widget _navigateBasedOnToken(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          bool tokenExists = snapshot.data ?? false;
          return tokenExists ? HomePage() : LoginPage();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Future<bool> checkToken() async { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; 
  }
}
