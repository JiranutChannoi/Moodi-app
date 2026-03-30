import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'home_screen.dart'; // ✅ import HomeScreen

class PHQ9ResultScreen extends StatefulWidget {
  final int score;
  final int maxScore;
  final String level;
  final String description;
  final Color color;

  const PHQ9ResultScreen({
    Key? key,
    required this.score,
    required this.maxScore,
    required this.level,
    required this.description,
    required this.color,
  }) : super(key: key);

  @override
  State<PHQ9ResultScreen> createState() => _PHQ9ResultScreenState();
}

class _PHQ9ResultScreenState extends State<PHQ9ResultScreen> {
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    if (_saved) return;
    try {
      await ApiService.saveQuizResult(
        userId: 1,
        quizType: 'PHQ9',
        totalScore: widget.score,
        level: widget.level,
      );
      _saved = true;
      debugPrint('✅ PHQ9 result saved: ${widget.score} - ${widget.level}');
    } catch (e) {
      debugPrint('❌ PHQ9 save error: $e');
    }
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
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'ผลการประเมินสุขภาพจิตใจ PHQ-9',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A1B9A),
                        ),
                      ),
                      SizedBox(height: 24),
                      TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        builder: (context, double value, child) {
                          return Transform.scale(scale: value, child: child);
                        },
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              _getEmoji(),
                              style: TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(24),
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
                          children: [
                            Text(
                              'ผลการประเมินสุขภาพจิตใจ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 16),
                            TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 1000),
                              builder: (context, double value, child) {
                                return RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            '${(widget.score * value).toInt()}',
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                          color: widget.color,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '/${widget.maxScore}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'ระดับ : ${widget.level}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: widget.color,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              widget.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),

                      // ✅ ปุ่ม "ทำแบบทดสอบใหม่" → pop 1 ครั้ง กลับไป PHQ9TestScreen
                      _buildActionButton(
                        context,
                        'ทำแบบทดสอบใหม่',
                        Colors.grey.shade700,
                        Icons.refresh,
                        () {
                          Navigator.pop(context); // กลับไป PHQ9TestScreen
                        },
                      ),
                      SizedBox(height: 12),

                      // ✅ ปุ่ม "กลับหน้าหลัก" → ไป HomeScreen แล้วล้าง stack ทั้งหมด
                      _buildActionButton(
                        context,
                        'กลับหน้าหลัก',
                        Colors.grey.shade500,
                        Icons.home,
                        () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                            (route) => false, // ลบ stack ทั้งหมด
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

  String _getEmoji() {
    if (widget.score <= 4) return '😊';
    if (widget.score <= 9) return '🙂';
    if (widget.score <= 14) return '😐';
    if (widget.score <= 19) return '😔';
    return '😢';
  }

  // ✅ ลูกศรย้อนกลับ → pop 1 หน้า กลับไป PHQ9TestScreen
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.pop(context), // กลับไป PHQ9TestScreen
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: color, size: 20),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
