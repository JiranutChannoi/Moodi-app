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
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.5),
      ),
      child: Center(child: Text('👆😊😐😢', style: TextStyle(fontSize: 40))),
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
