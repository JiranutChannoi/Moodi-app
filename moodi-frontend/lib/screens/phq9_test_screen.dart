import 'package:flutter/material.dart';
import 'phq9_result_screen.dart';

class PHQ9TestScreen extends StatefulWidget {
  const PHQ9TestScreen({Key? key}) : super(key: key);

  @override
  State<PHQ9TestScreen> createState() => _PHQ9TestScreenState();
}

class _PHQ9TestScreenState extends State<PHQ9TestScreen> {
  int currentQuestion = 0;
  List<int?> answers = List.filled(9, null);

  // คำถาม PHQ-9 จริงจากกระทรวงสาธารณสุข
  final List<String> questions = [
    '1. ไม่สนุกสนานกับกิจกรรมที่เคยชอบทำ หรือไม่รู้สึกสนุกกับสิ่งต่างๆ',
    '2. รู้สึกหดหู่ ท้อแท้ หรือสิ้นหวัง',
    '3. มีปัญหานอนไม่หลับ หรือนอนมากเกินไปกว่าปกติหรือหลับแล้วไม่สดชื่น',
    '4. รู้สึกเหนื่อยหรือไม่ค่อยมีแรง',
    '5. ไม่ค่อยอยากกินอะไร หรือกินมากเกินไป',
    '6. รู้สึกไม่ดีกับตนเอง หรือรู้สึกว่าตัวเองเป็นคนล้มเหลวหรือทำให้ตัวเองหรือครอบครัวผิดหวัง',
    '7. ไม่ค่อยมีสมาธิกับสิ่งต่างๆ เช่น การอ่านหนังสือหรือดูโทรทัศน์',
    '8. เคลื่อนไหวช้า หรือพูดช้าจนคนอื่นสามารถสังเกตเห็นได้ หรือในทางตรงข้ามคือ อยู่ไม่สุขกระสับกระส่าย จนเคลื่อนไหวมากกว่าปกติมาก',
    '9. มีความคิดว่า ควรจะตายจะดีกว่าหรือเอาไว้ทำร้ายตัวเอง',
  ];

  final List<Map<String, dynamic>> options = [
    {'label': 'ไม่มีเลย', 'score': 0},
    {'label': 'มีบางวัน', 'score': 1},
    {'label': 'มีค่อนข้างบ่อย', 'score': 2},
    {'label': 'มีเกือบทุกวัน', 'score': 3},
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

    // ตามเกณฑ์มาตรฐาน PHQ-9
    if (totalScore <= 4) {
      level = 'ไม่มีอาการซึมเศร้า';
      description =
          'คุณมีสุขภาพจิตที่ดี ไม่พบอาการซึมเศร้า ควรรักษาสุขภาพจิตที่ดีต่อไป';
      resultColor = Colors.green;
    } else if (totalScore <= 9) {
      level = 'มีอาการซึมเศร้าระดับน้อย';
      description =
          'คุณมีอาการซึมเศร้าเล็กน้อย แนะนำให้พักผ่อนให้เพียงพอ ออกกำลังกาย และทำกิจกรรมที่ชอบ';
      resultColor = Color(0xFF4CAF50);
    } else if (totalScore <= 14) {
      level = 'มีอาการซึมเศร้าระดับปานกลาง';
      description =
          'คุณมีอาการซึมเศร้าในระดับปานกลาง แนะนำให้พบแพทย์หรือนักจิตวิทยาเพื่อรับคำปรึกษา';
      resultColor = Colors.orange;
    } else if (totalScore <= 19) {
      level = 'มีอาการซึมเศร้าระดับรุนแรงปานกลาง';
      description =
          'คุณมีอาการซึมเศร้าค่อนข้างรุนแรง ควรพบแพทย์เพื่อรับการประเมินและรักษา';
      resultColor = Color(0xFFFF5722);
    } else {
      level = 'มีอาการซึมเศร้าระดับรุนแรงมาก';
      description =
          'คุณมีอาการซึมเศร้ารุนแรง แนะนำให้พบแพทย์ทันทีเพื่อรับการรักษาที่เหมาะสม หรือโทร 1323';
      resultColor = Colors.red;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PHQ9ResultScreen(
          score: totalScore,
          maxScore: 27,
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
            icon: Icon(Icons.arrow_back, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'แบบทดสอบสุขภาพจิตใจ PHQ-9',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
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
          'คำถามที่ ${currentQuestion + 1} จาก 9',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A1B9A),
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
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
                      ? Color(0xFF9C27B0).withOpacity(0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: answers[currentQuestion] == option['score']
                        ? Color(0xFF9C27B0)
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
                              ? Color(0xFF9C27B0)
                              : Colors.grey.shade400,
                          width: 2,
                        ),
                        color: answers[currentQuestion] == option['score']
                            ? Color(0xFF9C27B0)
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
                              ? Color(0xFF6A1B9A)
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
