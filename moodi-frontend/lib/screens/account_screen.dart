import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'overview_screen.dart';
import 'login_screen.dart';
import 'auth_service.dart';

// ═══════════════════════════════════════════════════════════
//  Account Screen
// ═══════════════════════════════════════════════════════════

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _currentNavIndex = 2;

  // ── State ──
  bool _isLoading = true;
  String _name = '';
  String _email = '';
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    // ── Step 1: แสดง cache ก่อนทันที (ไม่ให้หน้าว่าง) ──
    final cachedUser = await AuthService.getCurrentUser();
    if (cachedUser != null && mounted) {
      // ดึง user_id จาก cached user (รองรับทั้ง int และ String)
      final rawId = cachedUser['user_id'] ?? cachedUser['id'];
      _userId = rawId is int ? rawId : int.tryParse(rawId.toString());

      setState(() {
        _name  = cachedUser['name']  ?? '';
        _email = cachedUser['email'] ?? '';
        // ยังไม่ปิด loading → รอ API ยืนยัน
      });
    }

    // ── Step 2: ดึงจาก API เพื่ออัปเดตข้อมูลล่าสุด ──
    if (_userId != null) {
      final result = await AuthService.getUserProfile(_userId!);
      if (!mounted) return;

      if (result['success'] == true) {
        final user = result['user'];
        setState(() {
          _name  = user['name']  ?? _name;
          _email = user['email'] ?? _email;
        });
      }
      // ถ้า API fail → ใช้ค่า cache จาก Step 1 ต่อไปได้เลย
    }

    if (mounted) setState(() => _isLoading = false);
  }

  // ── initial ตัวอักษรแรกของชื่อ ──
  String get _initial =>
      _name.isNotEmpty ? _name.trim()[0].toUpperCase() : '?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB39DDB),
              Color(0xFFE1BEE7),
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'บัญชีผู้ใช้',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    // ── ปุ่ม Refresh ──
                    IconButton(
                      onPressed: _loadProfile,
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Content ──
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            // ── Avatar (แสดง initial ตัวอักษร) ──
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.elasticOut,
                              builder: (context, value, child) =>
                                  Transform.scale(scale: value, child: child),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9575CD),
                                      Color(0xFFBA68C8)
                                    ],
                                  ),
                                  border: Border.all(
                                      color: Colors.white, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    _initial,
                                    style: const TextStyle(
                                      fontSize: 52,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Name ──
                            _FadeSlide(
                              delay: 0,
                              child: Text(
                                _name.isNotEmpty ? _name : '—',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4A148C),
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            // ── Email ──
                            _FadeSlide(
                              delay: 100,
                              child: Text(
                                _email.isNotEmpty ? _email : '—',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF7B1FA2),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // ── Buttons ──
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                children: [
                                  _FadeSlide(
                                    delay: 200,
                                    child: _buildMenuButton(
                                      icon: Icons.settings,
                                      label: 'ตั้งค่าบัญชีผู้ใช้',
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => _SettingsScreen(
                                              userId: _userId!,
                                              currentName: _name,
                                            ),
                                          ),
                                        );
                                        // reload หลังกลับมา
                                        _loadProfile();
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _FadeSlide(
                                    delay: 300,
                                    child: _buildMenuButton(
                                      icon: Icons.logout,
                                      label: 'ออกจากระบบ',
                                      onTap: () => _showLogoutDialog(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),

              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Menu Button ──
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFB39DDB).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF9575CD).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF7E57C2), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A148C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF9E9E9E), size: 16),
          ],
        ),
      ),
    );
  }

  // ── Bottom Navigation ──
  Widget _buildBottomNavigation() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_rounded, 'Home', 0),
          _buildNavItem(Icons.bar_chart_rounded, 'ภาพรวม', 1),
          _buildNavItem(Icons.person_outline_rounded, 'บัญชี', 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 0) {
          Navigator.of(context).pop();
        } else if (index == 1) {
          setState(() => _currentNavIndex = 1);
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OverviewScreen()),
          );
          if (mounted) setState(() => _currentNavIndex = 2);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF9575CD).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF7E57C2)
                  : const Color(0xFFBDBDBD),
              size: 26,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7E57C2),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Logout Dialog ──
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEE5A6F).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  size: 48, color: Color(0xFFEE5A6F)),
            ),
            const SizedBox(height: 20),
            const Text(
              'ออกจากระบบ',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C)),
            ),
            const SizedBox(height: 12),
            const Text(
              'คุณต้องการออกจากระบบหรือไม่?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF7B1FA2)),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(
                          color: Color(0xFFB39DDB), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'ยกเลิก',
                      style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF7E57C2),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (!mounted) return;
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEE5A6F),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'ออกจากระบบ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Settings Screen — StatefulWidget (แก้ชื่อ + เปลี่ยนรหัสผ่าน)
// ═══════════════════════════════════════════════════════════

class _SettingsScreen extends StatefulWidget {
  final int userId;
  final String currentName;

  const _SettingsScreen({
    required this.userId,
    required this.currentName,
  });

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  late String _displayName;

  @override
  void initState() {
    super.initState();
    _displayName = widget.currentName;
  }

  // ────────────────────────────────────────────────
  //  UI
  // ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB39DDB),
              Color(0xFFE1BEE7),
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'ตั้งค่าบัญชีผู้ใช้',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // ── แก้ไขชื่อ ──
                      _SettingTile(
                        icon: Icons.person_outline,
                        title: 'แก้ไขชื่อ',
                        subtitle: _displayName.isNotEmpty ? _displayName : '—',
                        onTap: _openEditNameSheet,
                      ),
                      const SizedBox(height: 16),
                      // ── เปลี่ยนรหัสผ่าน ──
                      _SettingTile(
                        icon: Icons.lock_outline,
                        title: 'เปลี่ยนรหัสผ่าน',
                        subtitle: '••••••••',
                        onTap: _openChangePasswordSheet,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Bottom Sheet: แก้ไขชื่อ
  // ────────────────────────────────────────────────
  void _openEditNameSheet() {
    final ctrl = TextEditingController(text: _displayName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _EditNameSheet(
        controller: ctrl,
        userId: widget.userId,
        onSuccess: (newName) {
          // อัปเดต UI ทันที
          setState(() => _displayName = newName);
          _showSnack('อัปเดตชื่อเป็น "$newName" สำเร็จ', Colors.green);
        },
        onError: (msg) => _showSnack(msg, Colors.red),
      ),
    );
  }

  // ────────────────────────────────────────────────
  //  Bottom Sheet: เปลี่ยนรหัสผ่าน
  // ────────────────────────────────────────────────
  void _openChangePasswordSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => _ChangePasswordSheet(
        userId: widget.userId,
        onSuccess: () => _showSnack('เปลี่ยนรหัสผ่านสำเร็จ', Colors.green),
        onError: (msg) => _showSnack(msg, Colors.red),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Bottom Sheet: แก้ไขชื่อ
// ═══════════════════════════════════════════════════════════

class _EditNameSheet extends StatefulWidget {
  final TextEditingController controller;
  final int userId;
  final void Function(String newName) onSuccess;
  final void Function(String msg) onError;

  const _EditNameSheet({
    required this.controller,
    required this.userId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<_EditNameSheet> createState() => _EditNameSheetState();
}

class _EditNameSheetState extends State<_EditNameSheet> {
  bool _isLoading = false;

  Future<void> _submit() async {
    final newName = widget.controller.text.trim();
    if (newName.isEmpty) {
      widget.onError('กรุณากรอกชื่อ');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.updateName(
      userId: widget.userId,
      name: newName,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Navigator.pop(context);
      widget.onSuccess(newName);
    } else {
      widget.onError(result['message'] ?? 'เกิดข้อผิดพลาด');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── handle bar ──
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Title ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9575CD).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_outline,
                    color: Color(0xFF7E57C2), size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'แก้ไขชื่อ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C)),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── Input ──
          _DialogInput(
            controller: widget.controller,
            hint: 'ชื่อใหม่',
            icon: Icons.person_outline,
          ),

          const SizedBox(height: 24),

          // ── Buttons ──
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('ยกเลิก',
                      style: TextStyle(
                          color: Color(0xFF7E57C2),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E57C2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('บันทึก',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Bottom Sheet: เปลี่ยนรหัสผ่าน
// ═══════════════════════════════════════════════════════════

class _ChangePasswordSheet extends StatefulWidget {
  final int userId;
  final VoidCallback onSuccess;
  final void Function(String msg) onError;

  const _ChangePasswordSheet({
    required this.userId,
    required this.onSuccess,
    required this.onError,
  });

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // ── Validate ──
    if (_oldCtrl.text.isEmpty || _newCtrl.text.isEmpty || _confirmCtrl.text.isEmpty) {
      widget.onError('กรุณากรอกข้อมูลให้ครบทุกช่อง');
      return;
    }
    if (_newCtrl.text.length < 6) {
      widget.onError('รหัสผ่านใหม่ต้องมีอย่างน้อย 6 ตัวอักษร');
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      widget.onError('รหัสผ่านใหม่ไม่ตรงกัน');
      return;
    }
    if (_oldCtrl.text == _newCtrl.text) {
      widget.onError('รหัสผ่านใหม่ต้องไม่ซ้ำกับรหัสผ่านเดิม');
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.updatePassword(
      userId: widget.userId,
      oldPassword: _oldCtrl.text,
      newPassword: _newCtrl.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Navigator.pop(context);
      widget.onSuccess();
    } else {
      widget.onError(result['message'] ?? 'เกิดข้อผิดพลาด');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24 + bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── handle bar ──
          Container(
            width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── Title ──
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9575CD).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lock_outline,
                    color: Color(0xFF7E57C2), size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                'เปลี่ยนรหัสผ่าน',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C)),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ── รหัสผ่านเดิม ──
          _DialogInput(
            controller: _oldCtrl,
            hint: 'รหัสผ่านเดิม',
            icon: Icons.lock_outline,
            obscure: _obscureOld,
            onToggle: () => setState(() => _obscureOld = !_obscureOld),
          ),
          const SizedBox(height: 12),

          // ── รหัสผ่านใหม่ ──
          _DialogInput(
            controller: _newCtrl,
            hint: 'รหัสผ่านใหม่ (อย่างน้อย 6 ตัวอักษร)',
            icon: Icons.lock_outline,
            obscure: _obscureNew,
            onToggle: () => setState(() => _obscureNew = !_obscureNew),
          ),
          const SizedBox(height: 12),

          // ── ยืนยันรหัสผ่านใหม่ ──
          _DialogInput(
            controller: _confirmCtrl,
            hint: 'ยืนยันรหัสผ่านใหม่',
            icon: Icons.lock_outline,
            obscure: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),

          const SizedBox(height: 24),

          // ── Buttons ──
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('ยกเลิก',
                      style: TextStyle(
                          color: Color(0xFF7E57C2),
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7E57C2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                      : const Text('บันทึก',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Reusable Widgets
// ═══════════════════════════════════════════════════════════

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFB39DDB).withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF9575CD).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF7E57C2), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF4A148C),
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey[500])),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Color(0xFF9E9E9E), size: 16),
          ],
        ),
      ),
    );
  }
}

class _DialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final VoidCallback? onToggle;

  const _DialogInput({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F0FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFB39DDB).withOpacity(0.4), width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF7E57C2), size: 20),
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

// ── Fade + Slide animation ──
class _FadeSlide extends StatelessWidget {
  final Widget child;
  final int delay; // milliseconds

  const _FadeSlide({required this.child, this.delay = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}