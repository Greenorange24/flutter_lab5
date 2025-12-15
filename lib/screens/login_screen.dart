import 'package:flutter/material.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false; // State สำหรับ Remember Me

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // สร้าง User object
      final user = User(
        name: _emailController.text.split(
          '@',
        )[0], // ใช้ส่วนแรกของ email เป็นชื่อ
        email: _emailController.text,
      );

      // แสดงข้อมูล Remember Me (สำหรับ demo)
      debugPrint('Remember Me: $_rememberMe');

      // Navigation ไปหน้า Home พร้อมส่ง User object
      // แบบที่ 1: ใช้ Navigator.push (ไม่ใช้ Named Route)
      /*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
      */

      // แบบที่ 2: ใช้ Named Route พร้อม arguments
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: user, // ส่ง User object ไปด้วย
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่ระบบ'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ไอคอน
              const Icon(Icons.account_circle, size: 100, color: Colors.indigo),
              const SizedBox(height: 32),

              // อีเมล
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอีเมล';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // รหัสผ่าน
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกรหัสผ่าน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),

              // Remember Me Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                  ),
                  const Text('จดจำฉันไว้'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: หน้าลืมรหัสผ่าน
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('ฟีเจอร์ลืมรหัสผ่าน')),
                      );
                    },
                    child: const Text('ลืมรหัสผ่าน?'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ปุ่มเข้าสู่ระบบ
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // ลิงก์ไปหน้า Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ยังไม่มีบัญชี? '),
                  TextButton(
                    onPressed: () {
                      // Navigation แบบ Named Route
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text('ลงทะเบียน'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
