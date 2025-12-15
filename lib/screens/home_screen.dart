import 'package:flutter/material.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final dynamic user; // รับ User object จากหน้า Login

  const HomeScreen({super.key, this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _openProfile() async {
    final result = await Navigator.pushNamed(context, '/profile');
    if (result == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('อัปเดตข้อมูลเรียบร้อย')));
      setState(() {}); // รีเฟรชหากต้องการอัปเดต UI
    }
  }

  String _avatarText() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.isNotEmpty) return args[0].toUpperCase();
    if (args is Map &&
        args['name'] is String &&
        (args['name'] as String).isNotEmpty)
      return (args['name'] as String)[0].toUpperCase();
    return 'P';
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลจาก User object
    final userName = widget.user is User ? widget.user.name : 'Guest';
    final userEmail = widget.user is User ? widget.user.email : 'No email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'โปรไฟล์',
            onPressed: _openProfile,
            icon: CircleAvatar(child: Text(_avatarText())),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(_avatarText())),
              title: const Text('บัญชีของฉัน'),
              subtitle: const Text('แก้ไขข้อมูลส่วนตัว'),
              trailing: TextButton(
                onPressed: _openProfile,
                child: const Text('แก้ไข'),
              ),
              onTap: _openProfile,
            ),
          ),
          const SizedBox(height: 12),

          // แสดงข้อมูล User
          Text(
            'ยินดีต้อนรับ!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),

          // Card แสดงข้อมูล
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: const Text('ชื่อ'),
                    subtitle: Text(userName),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.indigo),
                    title: const Text('อีเมล'),
                    subtitle: Text(userEmail),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          // ปุ่ม Logout
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text('ออกจากระบบ'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // แสดง Dialog ยืนยันการ Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการออกจากระบบ'),
        content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // ปิด Dialog
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // ปิด Dialog
              // กลับไปหน้า Login และล้าง stack ทั้งหมด
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false, // ลบทุก route ใน stack
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ออกจากระบบ'),
          ),
        ],
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรุณาใส่อีเมล';
    final pattern = RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(v.trim())) return 'อีเมลไม่ถูกต้อง';
    return null;
  }

  String? _phoneValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรุณาใส่เบอร์โทรศัพท์';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (!RegExp(r'^0\d{8,9}$').hasMatch(digits))
      return 'รูปแบบเบอร์โทรไม่ถูกต้อง';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      // แทนที่ด้วยการเรียก API จริงเพื่อบันทึกข้อมูล
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('บันทึกเรียบร้อย')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('บันทึกไม่สำเร็จ: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'โปรไฟล์',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          // ...existing widgets...
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('แก้ไขข้อมูลส่วนตัว'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}
