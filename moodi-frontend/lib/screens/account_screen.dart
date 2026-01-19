import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

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
                      // Avatar
                      Container(
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

                      SizedBox(height: 16),

                      // Name
                      Text(
                        'Fair',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A148C),
                        ),
                      ),

                      SizedBox(height: 4),

                      // Email
                      Text(
                        'nandies1446@gmail.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7B1FA2),
                        ),
                      ),

                      SizedBox(height: 32),

                      // Menu Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            _buildMenuButton(
                              icon: Icons.history,
                              label: 'ตั้งค่าบัญชีผู้ใช้',
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'ไปยังหน้า: ตั้งค่าบัญชีผู้ใช้',
                                    ),
                                    backgroundColor: Color(0xFF7B68EE),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            _buildMenuButton(
                              icon: Icons.logout,
                              label: 'ออกจากระบบ',
                              onTap: () {
                                _showLogoutDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              _buildBottomNavigation(context),
            ],
          ),
        ),
      ),
    );
  }

  // Menu Button Widget
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color(0xFF7B68EE), size: 24),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A148C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Color(0xFF9E9E9E), size: 16),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Widget
  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB2EBF2), Color(0xFFB3E5FC), Color(0xFFD1C4E9)],
          stops: [0.0, 0.33, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomNavItem(
            context,
            Icons.home,
            'หน้าหลัก',
            false,
            () => Navigator.pop(context),
          ),
          _buildBottomNavItem(
            context,
            Icons.assessment,
            'ภาพรวม',
            false,
            () {},
          ),
          _buildBottomNavItem(context, Icons.person, 'บัญชี', true, () {}),
        ],
      ),
    );
  }

  // Bottom Navigation Item
  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isActive
                  ? Color(0xFF7B68EE).withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF7B68EE), size: 36),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF7B68EE),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Logout Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'ออกจากระบบ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: Text('คุณต้องการออกจากระบบหรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('ออกจากระบบสำเร็จ'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7B68EE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('ออกจากระบบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
