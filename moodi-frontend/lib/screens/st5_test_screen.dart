import 'package:flutter/material.dart';
import 'st5_result_screen.dart';

class ST5TestScreen extends StatefulWidget {
  const ST5TestScreen({Key? key}) : super(key: key);

  @override
  State<ST5TestScreen> createState() => _ST5TestScreenState();
}

class _ST5TestScreenState extends State<ST5TestScreen> {
  int currentQuestion = 0;
  List<int?> answers = List.filled(5, null);

  // คำถาม ST-5 จริงจากกระทรวงสาธารณสุข
  final List<String> questions = [
    'มีปัญหาการนอน นอนไม่หลับหรือนอนมาก',
    'มีสมาธิน้อยลง',
    'หงุดหงิด / กระสับกระส่าย / วิตกกังใจ',
    'รู้สึกเบื่อ เซ็ง',
    'ไม่อยากพบปะผู้คน',
  ];

  final List<Map<String, dynamic>> options = [
    {'label': 'ไม่มีเลย', 'score': 0},
    {'label': 'เป็นบางครั้ง', 'score': 1},
    {'label': 'เป็นบ่อยครั้ง', 'score': 2},
    {'label': 'เป็นประจำ', 'score': 3},
  ];

  void nextQuestion() {
    if (answers[currentQuestion] != null) {
      if (currentQuestion < questions.length - 1) {
        setState(() => currentQuestion++);
      } else {
        _calculateAndShowResult();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('กรุณาเลือกคำตอบก่อนดำเนินการต่อ'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _calculateAndShowResult() {
    int totalScore = answers.fold(0, (sum, answer) => sum + (answer ?? 0));
    String level;
    String description;
    Color resultColor;

    // เกณฑ์ ST-5: 0-4 = ปกติ, 5-9 = เล็กน้อย, 10-14 = ปานกลาง, 15+ = รุนแรง
    if (totalScore <= 4) {
      level = 'ไม่มีความเครียด';
      description = 'คุณมีสุขภาพจิตที่ดี ไม่พบความเครียด';
      resultColor = Colors.green;
    } else if (totalScore <= 9) {
      level = 'มีความเครียดเล็กน้อย';
      description = 'คุณมีความเครียดเล็กน้อย แนะนำให้พักผ่อนและผ่อนคลาย';
      resultColor = Color(0xFF4CAF50);
    } else if (totalScore <= 14) {
      level = 'มีความเครียดปานกลาง';
      description = 'คุณมีความเครียดในระดับปานกลาง แนะนำให้ปรึกษาผู้เชี่ยวชาญ';
      resultColor = Colors.orange;
    } else {
      level = 'มีความเครียดรุนแรง';
      description = 'คุณมีความเครียดรุนแรง แนะนำให้พบแพทย์โดยเร็ว';
      resultColor = Colors.red;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ST5ResultScreen(
          score: totalScore,
          maxScore: 15,
          level: level,
          description: description,
          color: resultColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentQuestion + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB2EBF2), Color(0xFF80DEEA), Colors.white],
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
                      _buildProgressBar(progress),
                      SizedBox(height: 24),
                      _buildQuestionCard(),
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
            icon: Icon(Icons.arrow_back, color: Color(0xFF00838F)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'แบบทดสอบความเครียด ST-5',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00838F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'คำถามที่ ${currentQuestion + 1} จาก 5',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF00838F),
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BCD4)),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard() {
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
            questions[currentQuestion],
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade800,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          ...List.generate(options.length, (index) {
            final option = options[index];
            return GestureDetector(
              onTap: () {
                setState(() {
                  answers[currentQuestion] = option['score'];
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: answers[currentQuestion] == option['score']
                      ? Color(0xFF00BCD4).withOpacity(0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: answers[currentQuestion] == option['score']
                        ? Color(0xFF00BCD4)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: answers[currentQuestion] == option['score']
                              ? Color(0xFF00BCD4)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: answers[currentQuestion] == option['score']
                            ? Color(0xFF00BCD4)
                            : Colors.transparent,
                      ),
                      child: answers[currentQuestion] == option['score']
                          ? Icon(Icons.check, color: Colors.white, size: 16)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option['label'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              answers[currentQuestion] == option['score']
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: answers[currentQuestion] == option['score']
                              ? Color(0xFF00838F)
                              : Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: nextQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: answers[currentQuestion] != null
                    ? Color(0xFF66BB6A)
                    : Colors.grey.shade400,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                currentQuestion < questions.length - 1 ? 'ต่อไป' : 'ส่งคำตอบ',
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
