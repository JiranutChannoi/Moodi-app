import 'package:flutter/material.dart';
import 'phq9_test_screen.dart';
import 'st5_test_screen.dart';

class MentalHealthAssessmentScreen extends StatefulWidget {
  const MentalHealthAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<MentalHealthAssessmentScreen> createState() =>
      _MentalHealthAssessmentScreenState();
}

class _MentalHealthAssessmentScreenState
    extends State<MentalHealthAssessmentScreen> {
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
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildIllustration(),
                      SizedBox(height: 20),
                      Text(
                        'แบบทดสอบสุขภาพจิต',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildTestCard(
                        title: 'แบบประเมินภาวะซึมเศร้า (PHQ-9)',
                        description:
                            'แบบประเมินภาพภาวะซึมเศร้าที่ให้บ่งยอดของอารมณ์ที่อ่อนไหวอยู่ใน 2 สัปดาห์ที่ผ่านมา จำนวน 9 ข้อ',
                        points: [
                          'ใช้เวลาประมาณ 5 นาที',
                          'ประเมินความรุนแรงของอาการซึมเศร้า',
                          'มาตรฐานสากลที่แพทย์ใช้อ้างอิงทั่วไป',
                        ],
                        color: Color(0xFF9C27B0),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PHQ9TestScreen(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      _buildTestCard(
                        title: 'แบบประเมินความเครียด (ST-5)',
                        description:
                            'แบบประเมิน ST-5 (Stress Test-5) คัดกรองความเครียดเพื่อประเมินความเสี่ยงในการเกิดโรคซึมเศร้า',
                        points: [
                          'ใช้เวลาประมาณ 3 นาที',
                          'คัดกรองความเสี่ยงความเครียด',
                          'ช่วยป้องกันและแก้ไขได้ตั้งแต่เนิ่นๆ',
                        ],
                        color: Color(0xFF00BCD4),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ST5TestScreen(),
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

  // ✅ เอารูปผู้ใช้ขวามือบนออก เหลือแค่ปุ่มย้อนกลับ
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 165,
          height: 165,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0xFFCE93D8).withOpacity(0.3), Colors.transparent],
              stops: [0.4, 1.0],
            ),
          ),
        ),
        Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.95),
                Colors.white.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFCE93D8).withOpacity(0.25),
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 25,
                offset: Offset(0, 10),
              ),
            ],
            border: Border.all(color: Color(0xFFCE93D8), width: 3),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF9C27B0).withOpacity(0.4),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF00BCD4).withOpacity(0.4),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFFE1BEE7).withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEmojiWithIcon(
                          '😊',
                          Color(0xFF4CAF50),
                          Icons.sentiment_very_satisfied,
                        ),
                        SizedBox(width: 12),
                        _buildEmojiWithIcon(
                          '😐',
                          Color(0xFFFF9800),
                          Icons.sentiment_neutral,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildEmojiWithIcon(
                          '😔',
                          Color(0xFFFF5722),
                          Icons.sentiment_dissatisfied,
                        ),
                        SizedBox(width: 12),
                        _buildEmojiWithIcon(
                          '😢',
                          Color(0xFF9C27B0),
                          Icons.sentiment_very_dissatisfied,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 25,
          child: Icon(Icons.auto_awesome, color: Color(0xFFCE93D8), size: 16),
        ),
        Positioned(
          bottom: 5,
          left: 20,
          child: Icon(
            Icons.auto_awesome,
            color: Color(0xFF00BCD4).withOpacity(0.6),
            size: 14,
          ),
        ),
        Positioned(
          top: 25,
          left: 10,
          child: Icon(
            Icons.favorite,
            color: Color(0xFF9C27B0).withOpacity(0.5),
            size: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmojiWithIcon(String emoji, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
      ),
      child: Text(emoji, style: TextStyle(fontSize: 26)),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String description,
    required List<String> points,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          ...points.map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: TextStyle(color: color, fontSize: 16)),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                'เริ่มทำแบบทดสอบ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
