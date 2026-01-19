import 'package:flutter/material.dart';
import 'dart:async';

class RelaxationScreen extends StatefulWidget {
  const RelaxationScreen({Key? key}) : super(key: key);

  @override
  State<RelaxationScreen> createState() => _RelaxationScreenState();
}

class _RelaxationScreenState extends State<RelaxationScreen> {
  // รายการเสียงธรรมชาติ
  final List<Map<String, dynamic>> soundList = [
    {
      'id': 'rain',
      'name': 'Rain',
      'nameTh': 'ฝน',
      'icon': '🌧️',
      'color': Color(0xFF64B5F6),
    },
    {
      'id': 'ocean',
      'name': 'Ocean Waves',
      'nameTh': 'คลื่นทะเล',
      'icon': '🌊',
      'color': Color(0xFF4FC3F7),
    },
    {
      'id': 'forest',
      'name': 'Forest Birds',
      'nameTh': 'นกป่า',
      'icon': '🦜',
      'color': Color(0xFF66BB6A),
    },
    {
      'id': 'wind',
      'name': 'Wind',
      'nameTh': 'ลมพัด',
      'icon': '💨',
      'color': Color(0xFF90CAF9),
    },
  ];

  String? selectedSound;
  int selectedMinutes = 5;
  bool isPlaying = false;
  Timer? countdownTimer;
  int remainingSeconds = 0;

  final List<int> timeOptions = [5, 10, 15, 30];

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    if (selectedSound == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาเลือกเสียงธรรมชาติก่อน'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      isPlaying = true;
      remainingSeconds = selectedMinutes * 60;
    });

    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    countdownTimer?.cancel();
    setState(() {
      isPlaying = false;
      remainingSeconds = 0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('เสร็จสิ้นการผ่อนคลาย'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1BEE7), Color(0xFFBBDEFB), Colors.white],
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Illustration
                      _buildIllustration(),

                      SizedBox(height: 24),

                      // Title
                      Text(
                        'ฟังเสียงธรรมชาติเพื่อผ่อนคลาย',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),

                      SizedBox(height: 8),

                      // Subtitle
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.headphones,
                              color: Color(0xFF9C27B0),
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'ผ่อนคลายกับเสียงธรรมชาติ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF7B1FA2),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Sound List
                      _buildSoundList(),

                      SizedBox(height: 24),

                      // Timer Controls
                      _buildTimerControls(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.pop(context),
          ),
          Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            child: Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Color(0xFFFFE4B5).withOpacity(0.5),
            Color(0xFFFFD4A3).withOpacity(0.5),
          ],
        ),
      ),
      child: Center(child: Text('🧘‍♀️', style: TextStyle(fontSize: 80))),
    );
  }

  Widget _buildSoundList() {
    return Column(
      children: soundList.map((sound) {
        final isSelected = selectedSound == sound['id'];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isPlaying) {
                stopTimer();
              }
              selectedSound = sound['id'];
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? sound['color'].withOpacity(0.2)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? sound['color']
                    : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: sound['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(sound['icon'], style: TextStyle(fontSize: 24)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    sound['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: Color(0xFF4A148C),
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? sound['color']
                        : Colors.grey.withOpacity(0.3),
                  ),
                  child: Icon(
                    isSelected ? Icons.check : Icons.play_arrow,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimerControls() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFE1BEE7).withOpacity(0.5),
            Color(0xFFBBDEFB).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.timer, color: Color(0xFF7B68EE), size: 20),
              SizedBox(width: 8),
              Text(
                'ตั้งเวลา',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Time Options
          if (!isPlaying)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: timeOptions.map((minutes) {
                final isSelected = selectedMinutes == minutes;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMinutes = minutes;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(0xFF7B68EE)
                          : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF7B68EE), width: 1),
                    ),
                    child: Text(
                      '$minutes นาที',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Color(0xFF7B68EE),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

          // Playing Timer Display
          if (isPlaying) ...[
            Text(
              formatTime(remainingSeconds),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            Text(
              'กำลังเล่น',
              style: TextStyle(fontSize: 14, color: Color(0xFF9C27B0)),
            ),
          ],

          SizedBox(height: 16),

          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isPlaying)
                ElevatedButton(
                  onPressed: startTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7B68EE),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'เริ่มฟัง',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              if (isPlaying)
                ElevatedButton(
                  onPressed: stopTimer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'หยุด',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
