import 'package:flutter/material.dart';
import 'mood_tracking_screen.dart'; // เพิ่ม import หน้าบันทึกอารมณ์
import 'relaxation_screen.dart';
import 'account_screen.dart';
import 'ai_chat_screen.dart';
import 'mental_health_assessment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ข้อมูล Weather Mood
  final List<Map<String, dynamic>> weatherMoods = [
    {
      'icon': '☀️',
      'title': 'สดใส',
      'message': 'ลองออกไปเจอแสงแดดเบา ๆ สัก 5 นาทีสิ 🌿',
      'gradient': [
        Color.fromARGB(255, 238, 224, 159),
        Color.fromARGB(255, 241, 204, 120),
      ],
    },
    {
      'icon': '🌤',
      'title': 'สบายใจ',
      'message': 'วันนี้เป็นวันที่ดีแล้วนะ เก็บความรู้สึกนี้ไว้ 💛',
      'gradient': [
        Color.fromARGB(255, 156, 235, 200),
        Color.fromARGB(255, 102, 229, 197),
      ],
    },
    {
      'icon': '🌧',
      'title': 'เหนื่อยนิดหน่อย',
      'message': 'หายใจลึก ๆ แล้วพักสายตาแป๊บนึงนะ 💜',
      'gradient': [Color(0xFFB8CFE6), Color(0xFF89ABD4)],
    },
    {
      'icon': '🌪',
      'title': 'สับสน',
      'message': 'เขียนความรู้สึกลงกระดาษ อาจช่วยให้เห็นชัดขึ้นได้ 📝',
      'gradient': [Color(0xFFD1CFE2), Color(0xFFA8A4C7)],
    },
    {
      'icon': '🌈',
      'title': 'มีกำลังใจ',
      'message': 'ทุกอย่างจะผ่านไป คุณทำได้แน่นอน! 🌟',
      'gradient': [Color(0xFFFFD5E5), Color(0xFFFFA4C9)],
    },
    {
      'icon': '⛅',
      'title': 'มีหวัง',
      'message': 'เมฆอาจมาบัง แต่ดวงอาทิตย์ยังอยู่เสมอ ☀️',
      'gradient': [Color(0xFFE8E8E8), Color(0xFFC2D9F0)],
    },
  ];

  late Map<String, dynamic> todayWeather;

  @override
  void initState() {
    super.initState();
    // สุ่มสถานะอารมณ์เมื่อเปิดหน้าจอ
    todayWeather = (List.from(weatherMoods)..shuffle()).first;
  }

  void _randomizeWeather() {
    setState(() {
      todayWeather = (List.from(weatherMoods)..shuffle()).first;
    });
  }

  // -------------------- Gradients พาสเทลสำหรับการ์ด (ปรับสีให้สวยขึ้น) --------------------
  final LinearGradient kPinkGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF48FB1), // ชมพูสดใส
      Color(0xFFF8BBD0), // ชมพูเข้ม
    ],
  );
  final LinearGradient kBlueGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF64B5F6), // ฟ้าใส
      Color(0xFFBBDEFB), // ฟ้าสดใส
    ],
  );
  final LinearGradient kPeachGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFAB91), // พีชอ่อน
      Color(0xFFFFCCBC), // ส้มพีช
    ],
  );
  final LinearGradient kMintGrad = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00BCD4), // มินท์อ่อน
      Color(0xFF80DEEA), // เขียวมินท์สดใส
    ],
  );
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundhomescreen.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0),
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

                      // Weather Your Mind
                      _buildWeatherMind(),
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

  // User Card Widget พร้อมภาพพื้นหลัง
  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
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
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    children: [
                      TextSpan(
                        text: 'รู้สึก ',
                        style: TextStyle(color: Color(0xFF0097A7)),
                      ),
                      TextSpan(
                        text: 'เหนื่อยใจ ',
                        style: TextStyle(
                          color: Color(0xFF6A1B9A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'หรือไม่ ',
                        style: TextStyle(color: Color(0xFF0097A7)),
                      ),
                      TextSpan(
                        text: 'สบายใจ ',
                        style: TextStyle(
                          color: Color(0xFF6A1B9A),
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: 'ใช่ไหม',
                        style: TextStyle(color: Color(0xFF0097A7)),
                      ),
                      TextSpan(
                        text: ' ...',
                        style: TextStyle(
                          color: Color(0xFF9C27B0),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  softWrap: false,
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 6),
                Text(
                  'โทรหาสายด่วนสุขภาพจิต 1323',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A148C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 205, 248, 245),
                    foregroundColor: Color(0xFF00695C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                  ),
                  child: Text(
                    'กดเพื่อโทรออก',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // รูปภาพโทรศัพท์ 1323
          Container(
            width: 120,
            height: 120,
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Image.asset(
                'assets/images/tel.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.phone_in_talk,
                    size: 50,
                    color: Color(0xFF6A1B9A),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Weather Your Mind Widget
  Widget _buildWeatherMind() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: List<Color>.from(todayWeather['gradient']),
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weather Your Mind',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 155, 127, 198),
                ),
              ),
              GestureDetector(
                onTap: _randomizeWeather,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.refresh, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Weather Icon
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.8, end: 1.0),
            duration: Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, double scale, child) {
              return Transform.scale(
                scale: scale,
                child: Text(
                  todayWeather['icon'],
                  style: TextStyle(fontSize: 64),
                ),
              );
            },
          ),
          SizedBox(height: 12),

          // Weather Title
          Text(
            'อารมณ์วันนี้: ${todayWeather['title']}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),

          // Weather Message
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              todayWeather['message'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 129, 129, 183),
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Small indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              weatherMoods.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: weatherMoods[index] == todayWeather
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Menu Grid
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
          () {
            // นำทางไปยังหน้าบันทึกอารมณ์
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodTrackingScreen(),
              ),
            );
          },
        ),
        _buildMenuCard('ผ่อนคลายจิตใจ', kBlueGrad, Icons.self_improvement, () {
          // ✅ แก้ไขตรงนี้ - นำทางไปยังหน้าผ่อนคลาย
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RelaxationScreen()),
          );
        }),
        _buildMenuCard('พูดคุยกับผู้ช่วย\nAI', kPeachGrad, Icons.smart_toy, () {
          // ✅ แก้ไขตรงนี้ - นำทางไปยังหน้า AI Chat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AIChatScreen()),
          );
        }),
        _buildMenuCard('ประเมิน\nสุขภาพจิต', kMintGrad, Icons.psychology, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MentalHealthAssessmentScreen(),
            ),
          );
        }),
      ],
    );
  }

  // Menu Card with Enhanced Effects
  Widget _buildMenuCard(
    String title,
    Gradient gradient,
    IconData icon,
    VoidCallback onTap,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                spreadRadius: 1,
                offset: const Offset(0, 5),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: -2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Transform.rotate(
                      angle: (1 - value) * 0.5,
                      child: child,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
              ),
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
                  shadows: [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // แก้ไขปุ่ม "สมุดสะท้อนความคิด"
  Widget _buildActionButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF9575CD), Color(0xFFD1C4E9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: Colors.white, size: 26),
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
          _buildBottomNavItem(Icons.home, 'หน้าหลัก', true),
          _buildBottomNavItem(Icons.assessment, 'ภาพรวม', false),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person, color: Color(0xFF7B68EE), size: 36),
                ),
                SizedBox(height: 4),
                Text(
                  'บัญชี',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7B68EE),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Item
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          if (label == 'บัญชี') {
            // ไปยังหน้าบัญชีผู้ใช้
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          } else {
            _navigateToPage(label);
          }
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
              color: isActive ? Color(0xFF7B68EE) : Color(0xFF7B68EE),
              size: 36,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              color: isActive ? Color(0xFF7B68EE) : Color(0xFF7B68EE),
              fontWeight: isActive ? FontWeight.w800 : FontWeight.normal,
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
  }
}
