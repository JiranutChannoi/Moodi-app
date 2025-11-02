import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'บันทึกอารมณ์',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Prompt'),
      home: const MoodTrackingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  int currentStep = 0;
  String? selectedMood;
  final TextEditingController noteController = TextEditingController();
  final List<Map<String, dynamic>> moodEntries = [];

  final List<Map<String, dynamic>> moods = [
    {
      'emoji': '😊',
      'label': 'Happy',
      'labelTh': 'มีความสุข',
      'color': const Color(0xFFFFD93D),
    },
    {
      'emoji': '😌',
      'label': 'Calm',
      'labelTh': 'สงบ',
      'color': const Color(0xFF6BCB77),
    },
    {
      'emoji': '😐',
      'label': 'Neutral',
      'labelTh': 'ปกติ',
      'color': const Color(0xFFA8DADC),
    },
    {
      'emoji': '😢',
      'label': 'Sad',
      'labelTh': 'เศร้า',
      'color': const Color(0xFF4D96FF),
    },
    {
      'emoji': '😰',
      'label': 'Anxious',
      'labelTh': 'วิตกกังวล',
      'color': const Color(0xFF9575CD),
    },
    {
      'emoji': '😡',
      'label': 'Angry',
      'labelTh': 'โกรธ',
      'color': const Color(0xFFFF6B6B),
    },
  ];

  // ---------- กำหนดสีการ์ด "แตกต่างตามอารมณ์" ----------
  List<Color> _gradientForMood(String label) {
    switch (label) {
      case 'Happy':
        return [
          const Color.fromARGB(255, 233, 232, 196),
          const Color.fromARGB(255, 229, 225, 159),
        ];
      case 'Calm':
        return [
          const Color.fromARGB(255, 191, 236, 225),
          const Color.fromARGB(255, 152, 236, 216),
        ];
      case 'Neutral':
        return [
          const Color.fromARGB(255, 179, 216, 227),
          const Color.fromARGB(255, 140, 214, 236),
        ];
      case 'Sad':
        return [const Color(0xFF90CAF9), const Color(0xFFB39DDB)];
      case 'Anxious':
        return [const Color(0xFFD1C4E9), const Color(0xFFD1C4E9)];
      case 'Angry':
        return [
          const Color.fromARGB(255, 233, 191, 191),
          const Color.fromARGB(255, 229, 142, 142),
        ];
      default:
        return [const Color(0xFFE0E0E0), const Color(0xFFBDBDBD)];
    }
  }

  void nextStep() {
    if (currentStep < 2) setState(() => currentStep++);
  }

  void previousStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  void saveMoodEntry() {
    if (selectedMood != null) {
      setState(() {
        moodEntries.add({
          'mood': selectedMood,
          'note': noteController.text,
          'timestamp': DateTime.now(),
        });
        selectedMood = null;
        noteController.clear();
        currentStep = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกอารมณ์สำเร็จ'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void deleteMoodEntry(int index) {
    setState(() => moodEntries.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/backgroud.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                const Color(0xFFF5E6FF).withOpacity(0.3),
                const Color(0xFFFFE8F0).withOpacity(0.5),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: currentStep == 0
                      ? _buildStep1()
                      : currentStep == 1
                      ? _buildStep2()
                      : _buildStep3(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 20,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
              padding: EdgeInsets.zero,
            ),
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'บันทึกอารมณ์ประจำวัน',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question Header
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.purple.shade300,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'วันนี้คุณรู้สึกอย่างไรบ้าง?',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Mood Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                        itemCount: moods.length,
                        itemBuilder: (context, index) {
                          final mood = moods[index];
                          final isSelected = selectedMood == mood['label'];

                          return GestureDetector(
                            onTap: () =>
                                setState(() => selectedMood = mood['label']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: mood['color'].withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? mood['color']
                                      : mood['color'].withOpacity(0.3),
                                  width: isSelected ? 3 : 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mood['emoji'],
                                    style: const TextStyle(fontSize: 36),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    mood['label'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Note Section
                      const Text(
                        'เขียนบันทึก',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: TextField(
                          controller: noteController,
                          maxLines: 4,
                          style: const TextStyle(
                            color: Color(0xFF4A148C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          cursorColor: const Color(0xFF7E57C2),
                          decoration: const InputDecoration(
                            hintText: 'วันนี้คุณรู้สึกอย่างไร...',
                            hintStyle: TextStyle(
                              color: Color(0xFF9C8CBF),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: selectedMood != null
                              ? saveMoodEntry
                              : null,
                          icon: const Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'บันทึก',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7FD87E),
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Bottom Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildBottomButton('+ บันทึกอารมณ์ใหม่', true, () {
                      setState(() {
                        selectedMood = null;
                        noteController.clear();
                      });
                    }),
                    const SizedBox(width: 12),
                    _buildBottomButton('ประวัติ', false, () {
                      setState(() => currentStep = 1);
                    }),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(String label, bool isPrimary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFFE8DCFF)
              : const Color.fromARGB(255, 112, 112, 243),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF9B7EDE)
                : const Color(0xFFB8B8FF),
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: label == 'ประวัติ'
                ? const Color(0xFFFFFFFF)
                : const Color(0xFF7B5FB8),
          ),
        ),
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      children: [
        const SizedBox(height: 16),

        // Emoji Row at top
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: moods.map((mood) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: mood['color'].withOpacity(0.2),
                border: Border.all(color: mood['color'], width: 2),
              ),
              child: Text(mood['emoji'], style: const TextStyle(fontSize: 20)),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Title
        Text(
          'บันทึกอารมณ์ประจำวัน',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple.shade700,
          ),
        ),

        const SizedBox(height: 24),

        // Question header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: Colors.purple.shade300,
                  size: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'ประวัติอารมณ์?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF5E35B1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: moodEntries.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_satisfied_alt,
                        size: 80,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'ยังไม่มีการบันทึกอารมณ์',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: moodEntries.length,
                  itemBuilder: (context, index) {
                    final entry = moodEntries[index];
                    final mood = moods.firstWhere(
                      (m) => m['label'] == entry['mood'],
                    );

                    return _buildHistoryCard(
                      entry: entry,
                      mood: mood,
                      onMore: () => _showDeleteDialog(index),
                    );
                  },
                ),
        ),

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: Colors.purple.shade300, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'กลับ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple.shade700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ------- การ์ดประวัติแบบกราเดียนต์ "ตามอารมณ์" + ขอบไล่สี + สีตัวอักษร 0xFF5E35B1 -------
  Widget _buildHistoryCard({
    required Map<String, dynamic> entry,
    required Map<String, dynamic> mood,
    required VoidCallback onMore,
  }) {
    final colors = _gradientForMood(mood['label']);
    const textColor = Color(0xFF5E35B1);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            colors.first.withOpacity(0.85),
            colors.last.withOpacity(0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(1.5),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.first.withOpacity(0.16),
              colors.last.withOpacity(0.10),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // วงกลมอีโมจิซ้าย
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.90),
                    boxShadow: [
                      BoxShadow(
                        color: colors.first.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    mood['emoji'],
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),

                // ชื่ออารมณ์ + วันที่
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mood['labelTh'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'วันที่บันทึก ${_formatDate(entry['timestamp'])}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // ไอคอนเมนู
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: textColor),
                  onPressed: onMore,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),

            // โน้ต (ข้อความ) - แสดงข้อความที่บันทึกจริง
            if ((entry['note'] as String).isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE3D7F7),
                    width: 1.2,
                  ),
                ),
                child: Text(
                  entry['note'] as String, // ✅ แสดงข้อความจริง
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year + 543}';
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'ยืนยันการลบ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        content: const Text('คุณต้องการลบรายการนี้หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteMoodEntry(index);
              Navigator.pop(context);
              if (moodEntries.isEmpty) setState(() => currentStep = 0);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() => _buildStep2();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}