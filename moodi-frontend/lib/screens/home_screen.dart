import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart'; // ✅ เพิ่ม import url_launcher
import 'mood_tracking_screen.dart';
import 'relaxation_screen.dart';
import 'account_screen.dart';
import 'ai_chat_screen.dart';
import 'mental_health_assessment_screen.dart';
import 'journal_main_screen.dart';
import 'overview_screen.dart';
import 'auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _userName = '';

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
  Timer? _weatherTimer;
  late AnimationController _weatherAnimController;
  late Animation<double> _weatherFadeAnimation;
  int _currentNavIndex = 0;
  late AnimationController _floatAnimController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    todayWeather = (List.from(weatherMoods)..shuffle()).first;

    _weatherAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _weatherFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _weatherAnimController, curve: Curves.easeInOut),
    );
    _floatAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _floatAnimController, curve: Curves.easeInOut),
    );
    _weatherAnimController.forward();
    _startAutoWeatherChange();
  }

  Future<void> _loadUserName() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        _userName = user?['name'] ?? user?['full_name'] ?? 'คุณ';
      });
    }
  }

  // ✅ method สำหรับโทรออกจริง
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่สามารถโทรออกได้ กรุณาลองใหม่อีกครั้ง'),
            backgroundColor: Color(0xFF6A1B9A),
          ),
        );
      }
    }
  }

  void _startAutoWeatherChange() {
    _weatherTimer = Timer.periodic(
      const Duration(seconds: 8),
      (_) => _changeWeather(),
    );
  }

  void _changeWeather() {
    _weatherAnimController.reverse().then((_) {
      setState(() {
        final random = Random();
        Map<String, dynamic> newWeather;
        do {
          newWeather = weatherMoods[random.nextInt(weatherMoods.length)];
        } while (newWeather == todayWeather);
        todayWeather = newWeather;
      });
      _weatherAnimController.forward();
    });
  }

  @override
  void dispose() {
    _weatherTimer?.cancel();
    _weatherAnimController.dispose();
    _floatAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroundhomescreen.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.transparent,
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildUserCard(),
                      const SizedBox(height: 20),
                      _buildWeatherMind(),
                      const SizedBox(height: 24),
                      _buildMenuGrid(),
                      const SizedBox(height: 24),
                      _buildJournalCard(),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hi $_userName 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Text(
                'ดูแลสุขภาพใจของคุณใจ...ทุกวันอย่างใส่ใจ',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 85, 9, 177),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  USER CARD
  // ══════════════════════════════════════

  Widget _buildUserCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/card_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.white38, BlendMode.lighten),
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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  overflow: TextOverflow.visible,
                  text: const TextSpan(
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
                ),
                const SizedBox(height: 6),
                const Text(
                  'โทรหาสายด่วนสุขภาพจิต 1323',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A148C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                // ✅ ปุ่มที่โทรออกได้จริง
                ElevatedButton.icon(
                  onPressed: () => _makePhoneCall('1323'),
                  icon: const Icon(Icons.phone_rounded, size: 16),
                  label: const Text(
                    'กดเพื่อโทรออก',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 205, 248, 245),
                    foregroundColor: const Color(0xFF00695C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 120,
            height: 120,
            child: Image.asset(
              'assets/images/tel.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.phone_in_talk,
                size: 50,
                color: Color(0xFF6A1B9A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════
  //  WEATHER MIND
  // ══════════════════════════════════════

  Widget _buildWeatherMind() {
    return FadeTransition(
      opacity: _weatherFadeAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
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
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weather Your Mind',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 155, 127, 198),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, double scale, child) =>
                  Transform.scale(scale: scale, child: child),
              child: Text(
                todayWeather['icon'],
                style: const TextStyle(fontSize: 64),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'อารมณ์วันนี้: ${todayWeather['title']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                todayWeather['message'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 129, 129, 183),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  MENU GRID
  // ══════════════════════════════════════

  Widget _buildMenuGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.95,
      children: [
        _buildCuteMenuCard(
          title: 'บันทึกความรู้สึก\nประจำวัน',
          character: _buildDiaryCharacter(),
          gradientColors: [const Color(0xFFE1F5FE), const Color(0xFFB3E5FC)],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MoodTrackingScreen()),
          ),
        ),
        _buildCuteMenuCard(
          title: 'ผ่อนคลาย\nจิตใจ',
          character: _buildMeditationCharacter(),
          gradientColors: [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RelaxationScreen()),
          ),
        ),
        _buildCuteMenuCard(
          title: 'พูดคุยกับ\nผู้ช่วย AI',
          character: _buildAIChatCharacter(),
          gradientColors: [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AIChatScreen()),
          ),
        ),
        _buildCuteMenuCard(
          title: 'ประเมิน\nสุขภาพจิต',
          character: _buildHealthCheckCharacter(),
          gradientColors: [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const MentalHealthAssessmentScreen(),
            ),
          ),
        ),
      ],
    );
  }

  // ══════════════════════════════════════
  //  CHARACTERS
  // ══════════════════════════════════════

  Widget _buildDiaryCharacter() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnimation.value),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -5,
              child: Container(
                width: 60,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Container(
              width: 65,
              height: 75,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF64B5F6), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1976D2).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              child: Container(
                width: 3,
                height: 75,
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Positioned(
              top: 22,
              left: 30,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0D47A1), width: 2),
                ),
              ),
            ),
            Positioned(
              top: 22,
              right: 18,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF0D47A1), width: 2),
                ),
              ),
            ),
            Positioned(
              top: 40,
              child: Container(
                width: 20,
                height: 10,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF0D47A1), width: 2),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 15,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  width: 4,
                  height: 35,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 4,
              top: 12,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF424242),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const Positioned(
              top: 5,
              left: 8,
              child: Icon(Icons.star, color: Color(0xFFFFEB3B), size: 14),
            ),
            const Positioned(
              bottom: 8,
              right: 8,
              child: Icon(Icons.star, color: Color(0xFFFFEB3B), size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeditationCharacter() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnimation.value * 0.8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -3,
              child: Container(
                width: 55,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Container(
              width: 55,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFBA68C8), Color(0xFFAB47BC)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8E24AA).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 18,
              left: 14,
              child: Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 14,
              child: Container(
                width: 10,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF6A1B9A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Positioned(
              top: 32,
              child: Container(
                width: 18,
                height: 8,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF6A1B9A), width: 2),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 2,
              child: Container(
                width: 18,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA68C8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Positioned(
              bottom: 15,
              right: 2,
              child: Container(
                width: 18,
                height: 15,
                decoration: BoxDecoration(
                  color: const Color(0xFFBA68C8),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Positioned(
              top: -5,
              child: Icon(Icons.spa, color: Color(0xFFCE93D8), size: 20),
            ),
            Positioned(
              top: -8,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEB3B).withOpacity(0.6),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFEB3B).withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIChatCharacter() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnimation.value * 1.2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -4,
              child: Container(
                width: 58,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Container(
              width: 60,
              height: 65,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB74D), Color(0xFFFF9800)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF57C00).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -5,
              left: 15,
              child: Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: 15,
              child: Container(
                width: 3,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Positioned(
              top: -8,
              left: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.6),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.6),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 12,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0277BD),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 12,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0277BD),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 18,
              child: Container(
                width: 25,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    5,
                    (_) => Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4FC3F7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF66BB6A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF5350),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthCheckCharacter() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _floatAnimation.value * 0.9),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: -3,
              child: Container(
                width: 60,
                height: 7,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
            Container(
              width: 65,
              height: 70,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF388E3C).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Container(
                width: 2,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFF388E3C).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 8,
              child: Container(
                width: 22,
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF388E3C), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 8,
              child: Container(
                width: 22,
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF388E3C), width: 2),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            Positioned(
              top: 22,
              left: 18,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B5E20),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 22,
              right: 18,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B5E20),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 42,
              child: Container(
                width: 20,
                height: 10,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF1B5E20), width: 2.5),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFFE57373),
                  size: 12,
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Color(0xFF388E3C),
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCuteMenuCard({
    required String title,
    required Widget character,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: 0.85 + 0.15 * value,
        child: Opacity(opacity: value, child: child),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: gradientColors[1].withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 90, child: character),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF37474F),
                    height: 1.3,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  JOURNAL CARD
  // ══════════════════════════════════════

  Widget _buildJournalCard() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: 0.85 + 0.15 * value,
        child: Opacity(opacity: value, child: child),
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JournalMainScreen()),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFF9C4), Color(0xFFFFF176)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFEB3B).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnimation.value * 0.6),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF57C00).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE65100),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE65100),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: 22,
                              height: 11,
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color(0xFFE65100),
                                    width: 2.5,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(
                        top: 5,
                        right: 5,
                        child: Icon(
                          Icons.auto_awesome,
                          color: Color(0xFFFFEB3B),
                          size: 16,
                        ),
                      ),
                      Positioned(
                        left: 12,
                        child: Container(
                          width: 3,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE65100).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'สมุดสะท้อนความคิด',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF37474F),
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'เขียนบันทึกความรู้สึก\nของคุณทุกวัน',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF78909C),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Color(0xFFFF9800),
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════
  //  BOTTOM NAVIGATION
  // ══════════════════════════════════════

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
        setState(() => _currentNavIndex = index);

        if (index == 1) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OverviewScreen()),
          );
          if (mounted) setState(() => _currentNavIndex = 0);
        } else if (index == 2) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AccountScreen()),
          );
          if (mounted) setState(() => _currentNavIndex = 0);
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
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    const Color(0xFF9575CD).withOpacity(0.15),
                    const Color(0xFFB39DDB).withOpacity(0.1),
                  ],
                )
              : null,
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
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: const TextStyle(
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
}
