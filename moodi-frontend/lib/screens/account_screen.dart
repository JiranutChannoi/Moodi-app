import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  int _currentNavIndex = 2; // เริ่มที่หน้าบัญชี

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB39DDB), // ม่วงอ่อน
              Color(0xFFE1BEE7), // ม่วงพาสเทล
              Color(0xFFBBDEFB), // ฟ้าอ่อน
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'บัญชีผู้ใช้',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Profile Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Avatar with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFB3BA),
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/avatar.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Name with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          'Fair',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A148C),
                          ),
                        ),
                      ),

                      SizedBox(height: 4),

                      // Email with Animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          'nandies1446@gmail.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7B1FA2),
                          ),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Menu Buttons with Staggered Animation
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: 0.8 + (0.2 * value),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: _buildMenuButton(
                                icon: Icons.settings,
                                label: 'ตั้งค่าบัญชีผู้ใช้',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => _SettingsScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutBack,
                              builder: (context, value, child) {
                                return Transform.scale(
                                  scale: 0.8 + (0.2 * value),
                                  child: Opacity(opacity: value, child: child),
                                );
                              },
                              child: _buildMenuButton(
                                icon: Icons.logout,
                                label: 'ออกจากระบบ',
                                onTap: () {
                                  _showLogoutDialog(context);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation (ใช้ดีไซน์เดียวกับหน้าหลัก)
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Menu Button Widget with Hover Effect
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFFB39DDB).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Color(0xFFB39DDB).withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9575CD).withOpacity(0.2),
                    Color(0xFFB39DDB).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF7E57C2), size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A148C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF9E9E9E), size: 16),
          ],
        ),
      ),
    );
  }

  // ✨ Bottom Navigation Widget (เหมือนหน้าหลัก)
  Widget _buildBottomNavigation() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSmoothNavItem(Icons.home_rounded, 'Home', 0),
          _buildSmoothNavItem(Icons.bar_chart_rounded, 'ภาพรวม', 1),
          _buildSmoothNavItem(Icons.person_outline_rounded, 'บัญชี', 2),
        ],
      ),
    );
  }

  // ✨ Smooth Bottom Navigation Item (แสดงชื่อเฉพาะเมื่อเลือก)
  Widget _buildSmoothNavItem(IconData icon, String label, int index) {
    final bool isActive = _currentNavIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentNavIndex = index;
        });

        if (index == 0) {
          // กลับไปหน้าหลัก
          Navigator.pop(context);
        } else if (index == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white),
                  SizedBox(width: 10),
                  Text('หน้าภาพรวมกำลังพัฒนา'),
                ],
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Color(0xFF7B68EE),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
        // index == 2 คือหน้าบัญชีที่เราอยู่แล้ว ไม่ต้องทำอะไร
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    Color(0xFF9575CD).withOpacity(0.15),
                    Color(0xFFB39DDB).withOpacity(0.1),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ไอคอน
            Icon(
              icon,
              color: isActive ? Color(0xFF7E57C2) : Color(0xFFBDBDBD),
              size: 26,
            ),

            // แสดงชื่อเฉพาะเมื่อเลือก
            if (isActive) ...[
              SizedBox(width: 8),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF7E57C2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                child: Text(label),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Enhanced Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6B6B).withOpacity(0.2),
                    Color(0xFFEE5A6F).withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.logout_rounded,
                size: 48,
                color: Color(0xFFEE5A6F),
              ),
            ),
            SizedBox(height: 20),

            // Title
            Text(
              'ออกจากระบบ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
              ),
            ),
            SizedBox(height: 12),

            // Content
            Text(
              'คุณต้องการออกจากระบบหรือไม่?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Color(0xFF7B1FA2)),
            ),
            SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Color(0xFFB39DDB), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF7E57C2),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Logout Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ปิด dialog
                      // แสดง SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              Text('ออกจากระบบสำเร็จ'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // รอ SnackBar แสดงแล้วค่อยออกจากหน้า
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context); // กลับไปหน้าหลัก
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEE5A6F),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Color(0xFFEE5A6F).withOpacity(0.4),
                    ),
                    child: Text(
                      'ออกจากระบบ',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

// ✨ Settings Screen (หน้าตั้งค่าบัญชีผู้ใช้)
class _SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'ตั้งค่าบัญชีผู้ใช้',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      _buildSettingItem(
                        icon: Icons.person_outline,
                        title: 'แก้ไขโปรไฟล์',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ฟีเจอร์กำลังพัฒนา'),
                              backgroundColor: Color(0xFF7B68EE),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      _buildSettingItem(
                        icon: Icons.lock_outline,
                        title: 'เปลี่ยนรหัสผ่าน',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ฟีเจอร์กำลังพัฒนา'),
                              backgroundColor: Color(0xFF7B68EE),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      _buildSettingItem(
                        icon: Icons.notifications_outlined,
                        title: 'การแจ้งเตือน',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ฟีเจอร์กำลังพัฒนา'),
                              backgroundColor: Color(0xFF7B68EE),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      _buildSettingItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'ความเป็นส่วนตัว',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('ฟีเจอร์กำลังพัฒนา'),
                              backgroundColor: Color(0xFF7B68EE),
                            ),
                          );
                        },
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

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFFB39DDB).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9575CD).withOpacity(0.2),
                    Color(0xFFB39DDB).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Color(0xFF7E57C2), size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A148C),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF9E9E9E), size: 16),
          ],
        ),
      ),
    );
  }
}
