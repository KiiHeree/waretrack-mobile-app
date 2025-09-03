import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waretrack/pages/deliveryComplete.dart';
import 'package:waretrack/pages/deliveryDetail.dart';
import 'package:waretrack/pages/homePage.dart';
import 'package:waretrack/pages/loginPage.dart';
import 'package:waretrack/pages/profile.dart';
import 'package:waretrack/pages/splash_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flight Booking App",
      theme: ThemeData(
        primaryColor: Color(0xFF3A86FF),
        colorScheme: ColorScheme.light(
          primary: Color(0xFF3A86FF),
          secondary: Color(0xFFFF006E),
          tertiary: Color(0xFFF8F9FA),
        ),
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
          bodyLarge: TextStyle(color: Color(0xFF64748B)),
          bodyMedium: TextStyle(color: Color(0xFF64748B)),
        ),
      ),

      initialRoute: '/splash', // Halaman awal
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/homePage': (context) => HomePage(),
        '/profilePage': (context) => Profile(),
        // '/deliveryDetailPage': (context) => DeliveryDetail(),
        '/deliveryCompletePage': (context) => DeliveryComplete(),
      },
    );
  }
}
