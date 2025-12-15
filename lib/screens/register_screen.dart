import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // สร้าง GlobalKey สำหรับ Form
  final _formKey = GlobalKey<FormState>();
  
  // Controllers สำหรับ TextFormField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // State สำหรับ Show/Hide Password
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // อย่าลืม dispose controllers!
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ฟังก์ชัน Validate Email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    // ใช้ RegExp ตรวจสอบรูปแบบอีเมล
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }

  // ฟังก์ชัน Validate Password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    return null;
  }

  // ฟังก์ชันจัดการการลงทะเบียน
  void _handleRegister() {
    // ตรวจสอบ Form ว่าผ่าน Validation หรือไม่
    if (_formKey.currentState!.validate()) {
      // แสดง SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ลงทะเบียนสำเร็จ!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigation ไปหน้า Login (แบบ Named Route)
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียน'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey, // ผูก GlobalKey กับ Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ไอคอนด้านบน
              const Icon(
                Icons.person_add,
                size: 80,
                color: Colors.indigo,
              ),
              const SizedBox(height: 32),

              // ชื่อ
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // อีเมล
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'อีเมล',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: _validateEmail,
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
                  // ปุ่ม Show/Hide Password
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
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),

              // ยืนยันรหัสผ่าน
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'ยืนยันรหัสผ่าน',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword 
                          ? Icons.visibility_off 
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณายืนยันรหัสผ่าน';
                  }
                  // ตรวจสอบว่าตรงกับรหัสผ่านหรือไม่
                  if (value != _passwordController.text) {
                    return 'รหัสผ่านไม่ตรงกัน';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // ปุ่มลงทะเบียน
              ElevatedButton(
                onPressed: _handleRegister,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'ลงทะเบียน',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),

              // ลิงก์ไปหน้า Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('มีบัญชีอยู่แล้ว? '),
                  TextButton(
                    onPressed: () {
                      // Navigation แบบ Named Route
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('เข้าสู่ระบบ'),
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