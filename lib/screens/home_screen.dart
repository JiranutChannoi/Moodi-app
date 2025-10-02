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
    '😊': 'มีความสุข',
    '😄': 'ดีใจ',
    '😐': 'ปกติ',
    '😔': 'เศร้า',
    '😡': 'โกรธ',
    '😰': 'กังวล',
  };

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

                      // Menu Grid
                      _buildMenuGrid(),
                      SizedBox(height: 24),

                      // Action Button
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

  // User Card Widget
  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
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
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to mood check
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 55, 208, 172),
                    foregroundColor: Color.fromARGB(255, 8, 126, 101),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text('กดเพื่อโทรออก', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          // Chart/Stats
          Container(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular Progress
                CircularProgressIndicator(
                  value: 0.65,
                  strokeWidth: 6,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B68EE)),
                ),
                // Center Text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1323',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B68EE),
                      ),
                    ),
                    Text(
                      'คะแนน',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Mood Selection Widget
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

        // Mood Icons Row
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
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

  // Menu Grid Widget
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
          Color(0xFFFFB6C1), // สีชมพู
          Icons.edit_note,
          () => _navigateToPage('บันทึกความรู้สึก'),
        ),
        _buildMenuCard(
          'ผ่อนคลายจิตใจ',
          Color(0xFF87CEEB), // สีฟ้า
          Icons.people,
          () => _navigateToPage('ชุมชน'),
        ),
        _buildMenuCard(
          'พูดคุยกับผู้ช่วย\nAI',
          Color(0xFFFFA07A), // สีส้ม
          Icons.smart_toy,
          () => _navigateToPage('AI Chatbot'),
        ),
        _buildMenuCard(
          'ประเมิน\nสุขภาพจิต',
          Color(0xFF98FB98), // สีเขียว
          Icons.psychology,
          () => _navigateToPage('ประเมินสุขภาพจิต'),
        ),
      ],
    );
  }

  // Menu Card Widget
  Widget _buildMenuCard(
    String title,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Button Widget
  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFFDDA0DD), // สีม่วงอ่อน
            Color(0xFFF0E68C), // สีเหลืองอ่อน
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
        child: Text(
          'สมุดสะท้อนความคิด',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
        if (!isActive) {
          _navigateToPage(label);
        }
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

    // ในอนาคตจะเพิ่ม navigation จริงๆ
    // Navigator.pushNamed(context, '/page-route');
  }
}
