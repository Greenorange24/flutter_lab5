import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form & Navigation Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      
      // กำหนดหน้าเริ่มต้น
      initialRoute: '/login',
      
      // กำหนด Named Routes
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // หมายเหตุ: HomeScreen ใช้ onGenerateRoute เพราะต้องรับ arguments
      },
      
      // ใช้สำหรับ routes ที่ต้องรับ arguments
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          final args = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => HomeScreen(user: args),
          );
        }
        return null;
      },
    );
  }
}