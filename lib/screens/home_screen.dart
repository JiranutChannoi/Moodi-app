import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = '';
  String moodTooltip = '';

  // ข้อมูลอารมณ์และข้อความ
  final Map<String, String> moodMap = {
    '😃': 'มีความสุข',
    '😌': 'สงบ',
    '😐': 'เฉยๆ',
    '😔': 'เศร้า',
    '😰': 'กังวล',
    '😡': 'โกรธ',
  };

  // -------------------- NEW: Gradients พาสเทลสำหรับการ์ด --------------------
  final LinearGradient kPinkGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)], // ชมพูพาสเทล
  );
  final LinearGradient kBlueGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAED9FF), Color(0xFF7EC8F8)], // ฟ้าพาสเทล
  );
  final LinearGradient kPeachGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF6D2B8), Color(0xFFF0B996)], // พีช/ส้มอ่อน
  );
  final LinearGradient kMintGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFBDEFD9), Color(0xFF7ED9C6)], // เขียวมินต์อ่อน
  );
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backkgroud.png'), // รูปพื้นหลัง
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9), // ทำให้พื้นหลังอ่อนลง
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Card แสดงข้อมูลผู้ใช้
                      _buildUserCard(),
                      SizedBox(height: 20),

                      // Mood Selection
                      _buildMoodSelection(),
                      SizedBox(height: 24),

                      // Menu Grid (UPDATED: ใช้ Gradients)
                      _buildMenuGrid(),
                      SizedBox(height: 24),

                      // Action Button (UPDATED: โทนเหลืองพาสเทล)
                      _buildActionButton(),
                    ],
                  ),
                ),
              ),

              // Bottom Navigation
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi Fair 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'ดูแลสุขภาพใจของคุณใจ...ทุกวันอย่างใส่ใจ',
                style: TextStyle(
                  fontSize: 14,
                  color: const Color.fromARGB(255, 85, 9, 177),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // User Card Widget พร้อมภาพพื้นหลัง
  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // เพิ่มภาพพื้นหลัง
        image: DecorationImage(
          image: AssetImage('assets/images/card_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.3),
            BlendMode.lighten,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 209, 184, 226).withOpacity(0.8),
            Color.fromARGB(255, 172, 205, 245).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รู้สึก เหนื่อยใจ หรือไม่ สบายใจ ใช่ไหม ...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color.fromARGB(221, 56, 2, 112),
                  ),
                ),
                Text(
                  'โทรหาสายด่วนสุขภาพจิต 1323',
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 70, 12, 141),
                  ),
                ),
                SizedBox(height: 9),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to mood check
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 205, 254, 242),
                    foregroundColor: Color.fromARGB(255, 5, 89, 71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('กดเพื่อโทรออก', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),

          // ไอคอนโทรศัพท์
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.phone,
              size: 40,
              color: Color.fromARGB(255, 70, 12, 141),
            ),
          ),
        ],
      ),
    );
  }

  // Mood Selection Widget พร้อมภาพพื้นหลัง (คงพฤติกรรมเดิม: แตะแล้วขึ้นข้อความ)
  Widget _buildMoodSelection() {
    return Column(
      children: [
        // Tooltip แสดงข้อความอารมณ์
        if (moodTooltip.isNotEmpty)
          Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF7B68EE),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              moodTooltip,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Mood Icons Row พร้อมภาพพื้นหลัง
        // Mood Icons Row พร้อมการไล่สี
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF7B68EE).withOpacity(0.3),
                Color(0xFFE8E4FF).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: moodMap.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMood = entry.key;
                    moodTooltip = entry.value;
                  });

                  // ซ่อน tooltip หลัง 2 วินาที
                  Future.delayed(Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        moodTooltip = '';
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedMood == entry.key
                        ? Color(0xFF7B68EE).withOpacity(0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(entry.key, style: TextStyle(fontSize: 32)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // -------------------- UPDATED: Menu Grid ใช้ Gradients --------------------
  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _buildMenuCard(
          'บันทึกความรู้สึก\nประจำวัน',
          kPinkGrad,
          Icons.edit_note,
          () => _navigateToPage('บันทึกความรู้สึก'),
        ),
        _buildMenuCard(
          'ผ่อนคลายจิตใจ',
          kBlueGrad,
          Icons.self_improvement,
          () => _navigateToPage('ชุมชน'),
        ),
        _buildMenuCard(
          'พูดคุยกับผู้ช่วย\nAI',
          kPeachGrad,
          Icons.smart_toy,
          () => _navigateToPage('AI Chatbot'),
        ),
        _buildMenuCard(
          'ประเมิน\nสุขภาพจิต',
          kMintGrad,
          Icons.psychology,
          () => _navigateToPage('ประเมินสุขภาพจิต'),
        ),
      ],
    );
  }

  // -------------------- UPDATED: Menu Card รองรับ Gradient + ไฮไลต์ --------------------
  Widget _buildMenuCard(
    String title,
    Gradient gradient,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox.expand(
            // ทำให้การ์ดขยายเต็มพื้นที่ช่อง
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ไฮไลต์มุมซ้ายบน (ถ้ามี)
          Positioned(
            top: -10,
            left: -10,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.55),
                    blurRadius: 20,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- UPDATED: Action Button พาสเทลเหลือง --------------------
  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFF9E7AE), // เหลืองนวล
            Color(0xFFF5C77E), // เหลืองอ่อนพาสเทล
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => _navigateToPage('สมุดสะท้อนความคิด'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'สมุดสะท้อนความคิด',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Navigation Widget
  Widget _buildBottomNavigation() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
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
          _buildBottomNavItem(Icons.home, 'หน้าหลัก', true),
          _buildBottomNavItem(Icons.assessment, 'ภาพรวม', false),
          _buildBottomNavItem(Icons.person, 'บัญชี', false),
        ],
      ),
    );
  }

  // Bottom Navigation Item
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) _navigateToPage(label);
      },
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
            child: Icon(
              icon,
              color: isActive ? Color(0xFF7B68EE) : Colors.grey[600],
              size: 24,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Color(0xFF7B68EE) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Function
  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ไปยังหน้า: $pageName'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF7B68EE),
      ),
    );
    // Navigator.pushNamed(context, '/page-route');
  }
}
