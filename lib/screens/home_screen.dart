import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = '';
  String moodTooltip = '';

  // ข้อมูลอารมณ์และต้นไม้
  final moodMap = <String, Map<String, dynamic>>{
    '😃': {'name': 'มีความสุข', 'plant': '🌻', 'color': Color(0xFFFFD700)},
    '😌': {'name': 'สงบ', 'plant': '🌿', 'color': Color(0xFF90EE90)},
    '😐': {'name': 'เฉยๆ', 'plant': '🌱', 'color': Color(0xFFB0C4DE)},
    '😔': {'name': 'เศร้า', 'plant': '🍂', 'color': Color(0xFFD2B48C)},
    '😰': {'name': 'กังวล', 'plant': '🌧️', 'color': Color(0xFFB0C4DE)},
    '😡': {'name': 'โกรธ', 'plant': '🔥', 'color': Color(0xFFFF6347)},
  };

  // เก็บประวัติการรดน้ำ
  List<String> plantedMoods = [];
  int gardenLevel = 1;

  // Gradients พาสเทลสำหรับการ์ด
  final LinearGradient kPinkGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
  );
  final LinearGradient kBlueGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFAED9FF), Color(0xFF7EC8F8)],
  );
  final LinearGradient kPeachGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF6D2B8), Color(0xFFF0B996)],
  );
  final LinearGradient kMintGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFBDEFD9), Color(0xFF7ED9C6)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backkgroud.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.9),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildUserCard(),
                      SizedBox(height: 20),
                      _buildMoodGarden(), // สวนอารมณ์ใหม่
                      SizedBox(height: 24),
                      _buildMenuGrid(),
                      SizedBox(height: 24),
                      _buildActionButton(),
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
                  onPressed: () {},
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

  // สวนอารมณ์ใหม่
  Widget _buildMoodGarden() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF87CEEB).withOpacity(0.3), // ท้องฟ้า
            Color(0xFF90EE90).withOpacity(0.3), // พื้นหญ้า
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('🌱', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text(
                    'สวนอารมณ์ของคุณ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Lv.$gardenLevel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Tooltip
          if (moodTooltip.isNotEmpty)
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B68EE), Color(0xFF9B59B6)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7B68EE).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(selectedMood, style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    moodMap[selectedMood]?['plant'] ?? '',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: 8),
                  Text(
                    moodTooltip,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // พื้นที่สวน
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF8FBC8F).withOpacity(0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Color(0xFF2E7D32).withOpacity(0.3),
                width: 2,
              ),
            ),
            child: plantedMoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('🌱', style: TextStyle(fontSize: 32)),
                        SizedBox(height: 4),
                        Text(
                          'รดน้ำต้นไม้ด้วยการบันทึกอารมณ์',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: plantedMoods.map((plant) {
                      return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500),
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Text(
                              plant,
                              style: TextStyle(fontSize: 32 * value),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
          SizedBox(height: 16),

          Text(
            plantedMoods.isEmpty
                ? 'เลือกอารมณ์วันนี้เพื่อปลูกต้นไม้ในสวน'
                : 'คุณปลูกต้นไม้แล้ว ${plantedMoods.length} ต้น',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),

          // Grid ปุ่มปลูก
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
            children: moodMap.entries.map((entry) {
              return _buildMoodPlant(
                entry.key,
                entry.value['name'] as String,
                entry.value['plant'] as String,
                entry.value['color'] as Color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodPlant(
    String emoji,
    String moodText,
    String plant,
    Color color,
  ) {
    bool isSelected = selectedMood == emoji;

    return GestureDetector(
      onTap: () => _waterPlant(emoji, moodText, plant),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [color.withOpacity(0.6), color.withOpacity(0.3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.5),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: TextStyle(fontSize: isSelected ? 36 : 32)),
            SizedBox(height: 4),
            Text(plant, style: TextStyle(fontSize: 20)),
            SizedBox(height: 2),
            Text(
              moodText,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _waterPlant(String emoji, String moodText, String plant) {
    setState(() {
      selectedMood = emoji;
      moodTooltip = moodText;

      if (!plantedMoods.contains(plant) || plantedMoods.length < 12) {
        plantedMoods.add(plant);
        if (plantedMoods.length % 5 == 0) {
          gardenLevel++;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(plant, style: TextStyle(fontSize: 20)),
            SizedBox(width: 8),
            Expanded(child: Text('ปลูก$plant "$moodText" ลงสวนแล้ว!')),
            Icon(Icons.park, color: Colors.white, size: 20),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Future.delayed(Duration(seconds: 3), () {
      if (mounted) setState(() => moodTooltip = '');
    });
  }

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
          () => _navigateToPage('ผ่อนคลาย'),
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

  Widget _buildMenuCard(
    String title,
    Gradient gradient,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: Offset(0, 6),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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

  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF9E7AE), Color(0xFFF5C77E)],
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

  void _navigateToPage(String pageName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('ไปยังหน้า: $pageName'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF7B68EE),
      ),
    );
  }
}
