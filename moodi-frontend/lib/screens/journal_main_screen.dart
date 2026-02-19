import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// ============================================================================
// JOURNAL MAIN - บันทึกความคิด
// ============================================================================

class JournalMainScreen extends StatefulWidget {
  const JournalMainScreen({Key? key}) : super(key: key);

  @override
  State<JournalMainScreen> createState() => _JournalMainScreenState();
}

class _JournalMainScreenState extends State<JournalMainScreen>
    with SingleTickerProviderStateMixin {
  String selectedIssue = 'ปัญหาในการทำงาน';
  String selectedFeeling = 'โกรธ';
  final thoughtsController = TextEditingController();
  final actionsController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  final List<Map<String, dynamic>> issues = [
    {'label': 'ปัญหาในการทำงาน', 'selected': true},
    {'label': 'ความขัดแย้งกับครอบครัว', 'selected': false},
    {'label': 'ความเครียดจากการเรียน', 'selected': false},
    {'label': 'ปัญหาครอบครัว', 'selected': false},
    {'label': 'ความกังวลใจ', 'selected': false},
    {'label': 'การดำเนินชีวิตยาก', 'selected': false},
    {'label': 'ความยึดติดมากเกินไป', 'selected': false},
    {'label': 'การเปลี่ยนแปลงตัวเอง', 'selected': false},
  ];

  final List<Map<String, dynamic>> feelings = [
    {'emoji': '😊', 'label': 'มีความสุข', 'selected': false},
    {'emoji': '😴', 'label': 'เหนื่อย', 'selected': false},
    {'emoji': '😢', 'label': 'เศร้า', 'selected': false},
    {'emoji': '😰', 'label': 'กังวลใจ', 'selected': false},
    {'emoji': '🙂', 'label': 'โอเคดี', 'selected': false},
    {'emoji': '😀', 'label': 'เฮฮา', 'selected': false},
    {'emoji': '😭', 'label': 'ร้องไห้', 'selected': false},
    {'emoji': '😡', 'label': 'โกรธ', 'selected': true},
    {'emoji': '😔', 'label': 'ผิดหวัง', 'selected': false},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    thoughtsController.dispose();
    actionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8D5F0), Color(0xFFD4E9F7), Color(0xFFF8F9FA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIllustration(),
                        const SizedBox(height: 20),
                        _buildTitle(),
                        const SizedBox(height: 12),
                        _buildMotivationalText(),
                        const SizedBox(height: 24),
                        _buildSubtitle('เหตุการณ์ที่เกิดขึ้น'),
                        const SizedBox(height: 12),
                        _buildIssuesGrid(),
                        const SizedBox(height: 20),
                        _buildSelectedIssue(),
                        const SizedBox(height: 16),
                        _buildSubtitle('ความรู้สึกที่เกิดขึ้น'),
                        const SizedBox(height: 12),
                        _buildFeelingsGrid(),
                        const SizedBox(height: 20),
                        _buildThoughtsSection(),
                        const SizedBox(height: 16),
                        _buildActionsSection(),
                        const SizedBox(height: 24),
                        _buildSaveButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ========== HEADER ==========
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildBackButton(context),
          const Spacer(),
          _buildHistoryButton(context),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C7AB8).withOpacity(0.2),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7B5A96), size: 20),
        ),
      ),
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JournalHistoryScreen()),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF81C784), Color(0xFF66BB6A)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF81C784).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('ประวัติ', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // ========== ANIMATED ILLUSTRATION ==========
  Widget _buildIllustration() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // พื้นเงา
                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: 120,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C7AB8).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF9C7AB8).withOpacity(0.2),
                              blurRadius: 25,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // กระดาษเหลือง (ด้านหลัง)
                    _buildPaper(
                      right: 25,
                      top: 35,
                      angle: 0.12,
                      colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                      shadowColor: Color(0xFFFFD93D),
                    ),
                    // กระดาษชมพู (หลัก)
                    _buildPaper(
                      top: 30,
                      colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                      shadowColor: Color(0xFFFF9AA2),
                    ),
                    // หลอดไฟ
                    Positioned(
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD93D).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 6,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Text('💡', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    // ประกายแสง
                    _buildSparkle(top: 15, right: 35, size: 10),
                    _buildSparkle(top: 8, left: 40, size: 7),
                    _buildSparkle(top: 22, left: 30, size: 5),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // กระดาษ component
  Widget _buildPaper({
    double? top,
    double? right,
    double angle = 0,
    required List<Color> colors,
    required Color shadowColor,
  }) {
    return Positioned(
      top: top,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: shadowColor.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),
              _buildLine(12, 14),
              const SizedBox(height: 10),
              _buildLine(12, 22),
              const SizedBox(height: 10),
              _buildLine(12, 18),
            ],
          ),
        ),
      ),
    );
  }

  // เส้นในกระดาษ
  Widget _buildLine(double left, double right) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right),
      child: Container(
        height: 2.5,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  // ประกายแสง
  Widget _buildSparkle({double? top, double? left, double? right, required double size}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEB3B).withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFEB3B).withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  // ========== TEXT SECTIONS ==========
  Widget _buildTitle() {
    return const Center(
      child: Text(
        'สมุดสะท้อนความคิด',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E)),
      ),
    );
  }

  Widget _buildMotivationalText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFF9E6), Color(0xFFFFFDF5)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFFD54F).withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFD54F), Color(0xFFFFCA28)]),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('บันทึกความคิดของคุณ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E))),
                SizedBox(height: 4),
                Text('เขียนสะท้อนวันนี้ เพื่อเข้าใจตัวเองมากขึ้น',
                    style: TextStyle(fontSize: 13, color: Color(0xFF8D6E63))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold),
    );
  }

  // ========== ISSUE SELECTION ==========
  Widget _buildIssuesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: issues.length,
      itemBuilder: (context, index) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                for (var issue in issues) {
                  issue['selected'] = false;
                }
                issues[index]['selected'] = true;
                selectedIssue = issues[index]['label'];
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: _buildChip(issues[index]['label'], issues[index]['selected'],
                const Color(0xFFB8D4F1), const Color(0xFF4A6FA5)),
          ),
        );
      },
    );
  }

  Widget _buildSelectedIssue() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFE8F4F8), Color(0xFFF5FAFC)]),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8D4F1).withOpacity(0.6), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF90B8E8), Color(0xFFADCBEE)]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.event_note, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('เหตุการณ์ : $selectedIssue',
                style: const TextStyle(fontSize: 14, color: Color(0xFF4A6FA5), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ========== FEELING SELECTION ==========
  Widget _buildFeelingsGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: feelings.asMap().entries.map((entry) {
        int index = entry.key;
        var feeling = entry.value;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              setState(() {
                for (var f in feelings) {
                  f['selected'] = false;
                }
                feelings[index]['selected'] = true;
                selectedFeeling = feelings[index]['label'];
              });
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                gradient: feeling['selected']
                    ? const LinearGradient(colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)])
                    : null,
                color: feeling['selected'] ? null : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: feeling['selected']
                      ? const Color(0xFFD4B5E8).withOpacity(0.6)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(feeling['emoji'], style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 7),
                  Text(
                    feeling['label'],
                    style: TextStyle(
                      fontSize: 13,
                      color: feeling['selected'] ? const Color(0xFF7B5A96) : const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Chip reusable widget
  Widget _buildChip(String label, bool selected, Color selectedColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(colors: [selectedColor, selectedColor.withOpacity(0.8)])
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? selectedColor.withOpacity(0.6) : const Color(0xFFE0E0E0),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? textColor : const Color(0xFF7B5A96),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  // ========== INPUT SECTIONS ==========
  Widget _buildThoughtsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Text('ความรู้สึก : $selectedFeeling',
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        const Text('แนวทางที่ใช้จัดการปัญหา',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTextField(thoughtsController, 'อธิบายวิธีที่คุณใช้จัดการกับสถานการณ์ที่เกิดขึ้น......'),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('สิ่งที่เรียนรู้ หรืออยากทำให้ดีขึ้นในอนาคต',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildTextField(actionsController, 'เขียนสิ่งที่คุณได้รับหรือต้องการปรับปรุงในอนาคต.....'),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
        boxShadow: [
          BoxShadow(color: const Color(0xFF9C7AB8).withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
      ),
    );
  }

  // ========== SAVE BUTTON ==========
  Widget _buildSaveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleSave,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF66BB6A), Color(0xFF81C784)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: const Color(0xFF66BB6A).withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text('บันทึกความคิด',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  // บันทึกข้อมูล
  Future<void> _handleSave() async {
    // ตรวจสอบข้อมูล
    if (thoughtsController.text.isEmpty || actionsController.text.isEmpty) {
      _showSnackBar('กรุณากรอกข้อมูลให้ครบถ้วน', const Color(0xFFFF9AA2));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      _showSnackBar('กรุณาเข้าสู่ระบบใหม่', Colors.red);
      return;
    }

    // บันทึกลง database
    final success = await ApiService.createDiary({
      'user_id': userId,
      'mood': selectedFeeling,
      'event': selectedIssue,
      'solution': thoughtsController.text,
      'improve': actionsController.text,
    });

    if (success) {
      thoughtsController.clear();
      actionsController.clear();
      _showSnackBar('บันทึกความคิดเรียบร้อยแล้ว', const Color(0xFF66BB6A));
    } else {
      _showSnackBar('บันทึกไม่สำเร็จ กรุณาลองใหม่', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }
}

// ============================================================================
// JOURNAL HISTORY - ประวัติบันทึก ✅ แก้ไขแล้ว
// ============================================================================

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> diaryEntries = [];
  bool isLoading = true;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _floatAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadDiary();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ✅ โหลดข้อมูลจาก API
  Future<void> _loadDiary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      print('🔍 Loading diary for user: $userId');

      if (userId == null) {
        print('❌ User ID is null');
        setState(() => isLoading = false);
        return;
      }

      final data = await ApiService.getDiaryByUser(userId);
      print('✅ Loaded ${data.length} diary entries');

      setState(() {
        diaryEntries = data.map<Map<String, dynamic>>((e) {
          // แปลงวันที่
          String formattedDate = 'ไม่ระบุวันที่';
          try {
            if (e['createdAt'] != null || e['created_at'] != null) {
              final dateStr = (e['createdAt'] ?? e['created_at']).toString();
              final date = DateTime.parse(dateStr).toLocal();
              formattedDate = '${date.day}/${date.month}/${date.year + 543} '
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} น.';
            }
          } catch (err) {
            print('⚠️ Date parse error: $err');
          }

          return {
            'id': e['entry_id'] ?? e['id'] ?? 0,
            'date': formattedDate,
            'issue': (e['event'] ?? 'ไม่ระบุเหตุการณ์').toString(),
            'feeling': (e['mood'] ?? 'ไม่ระบุอารมณ์').toString(),
            'thoughts': (e['solution'] ?? 'ไม่ระบุ').toString(),
            'actions': (e['improve'] ?? 'ไม่ระบุ').toString(),
          };
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading diary: $e');
      setState(() {
        isLoading = false;
        diaryEntries = [];
      });
      _showSnackBar('เกิดข้อผิดพลาดในการโหลดข้อมูล', Colors.red);
    }
  }

  // ลบบันทึก
  Future<void> _deleteDiary(int index) async {
    try {
      final entryId = diaryEntries[index]['id'];
      print('🗑️ Deleting entry: $entryId');

      final success = await ApiService.deleteDiary(entryId);

      if (success) {
        setState(() => diaryEntries.removeAt(index));
        _showSnackBar('ลบบันทึกเรียบร้อยแล้ว', const Color(0xFF66BB6A));
      } else {
        _showSnackBar('ลบไม่สำเร็จ', Colors.red);
      }
    } catch (e) {
      print('❌ Delete error: $e');
      _showSnackBar('เกิดข้อผิดพลาด', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == const Color(0xFF66BB6A) ? Icons.check_circle_rounded : Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8D5F0), Color(0xFFD4E9F7), Color(0xFFF8F9FA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF9C7AB8)))
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C7AB8).withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF7B5A96), size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // เนื้อหาหลัก
  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 30),
          _buildIllustration(),
          const SizedBox(height: 20),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
          const SizedBox(height: 24),
          _buildHistoryHeader(),
          const SizedBox(height: 16),
          diaryEntries.isEmpty ? const _EmptyState() : _buildDiaryList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Illustration (คัดลอกจาก main screen - เหมือนเดิม 100%)
  Widget _buildIllustration() {
    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // พื้นเงา
                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: 120,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFF9C7AB8).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                    // กระดาษเหลือง
                    _buildPaper(
                      right: 25,
                      top: 35,
                      angle: 0.12,
                      colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                    ),
                    // กระดาษชมพู
                    _buildPaper(
                      top: 30,
                      colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                    ),
                    // หลอดไฟ
                    Positioned(
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD93D).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Text('💡', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    _buildSparkle(top: 15, right: 35, size: 10),
                    _buildSparkle(top: 8, left: 40, size: 7),
                    _buildSparkle(top: 22, left: 30, size: 5),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaper({double? top, double? right, double angle = 0, required List<Color> colors}) {
    return Positioned(
      top: top,
      right: right,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 90,
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),
              _buildLine(14, 14),
              const SizedBox(height: 10),
              _buildLine(14, 22),
              const SizedBox(height: 10),
              _buildLine(14, 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLine(double left, double right) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: left),
      child: Container(height: 2.5, color: Colors.white.withOpacity(0.5)),
    );
  }

  Widget _buildSparkle({double? top, double? left, double? right, required double size}) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEB3B).withOpacity(0.8),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: const Color(0xFFFFEB3B).withOpacity(0.6), blurRadius: 10)],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'สมุดสะท้อนความคิด',
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E)),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFFFFD54F).withOpacity(0.2),
            const Color(0xFFFFCA28).withOpacity(0.15),
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'ย้อนดูความคิดและการเติบโตของคุณ',
          style: TextStyle(fontSize: 13, color: Color(0xFF8D6E63), fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          const Color(0xFFE8D5F0).withOpacity(0.5),
          const Color(0xFFD4E9F7).withOpacity(0.4),
        ]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4B5E8).withOpacity(0.4), width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF9C7AB8), Color(0xFFAB8FC9)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.history_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ประวัติบันทึก',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E))),
                SizedBox(height: 4),
                Text('บันทึกทั้งหมดของคุณ', style: TextStyle(fontSize: 12, color: Color(0xFF8D6E63))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFB3BA), Color(0xFFFF9AA2)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${diaryEntries.length}',
              style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // รายการบันทึก
  Widget _buildDiaryList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: diaryEntries.length,
      itemBuilder: (context, index) => _buildDiaryCard(diaryEntries[index], index),
    );
  }

  // การ์ดบันทึก
  Widget _buildDiaryCard(Map<String, dynamic> entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        boxShadow: [
          BoxShadow(color: const Color(0xFF9C7AB8).withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(entry['date'],
                      style: const TextStyle(fontSize: 13, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold)),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showDeleteDialog(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF5350), size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('เหตุการณ์', entry['issue']),
                const SizedBox(height: 10),
                _buildInfoRow('ความรู้สึกที่เกิดขึ้น', entry['feeling']),
                const SizedBox(height: 12),
                _buildTextSection('แนวทางที่ใช้จัดการปัญหา', entry['thoughts']),
                const SizedBox(height: 10),
                _buildTextSection('สิ่งที่เรียนรู้ หรืออยากทำให้ดีขึ้นในอนาคต', entry['actions']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
          children: [
            TextSpan(
                text: '$label : ',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E))),
            TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF424242))),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSection(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B4E7E), fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
          child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF424242), height: 1.5)),
        ),
      ],
    );
  }

  // Dialog ลบ
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFEF5350), Color(0xFFE53935)]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            const Text('ลบบันทึก',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E), fontSize: 20)),
          ],
        ),
        content: const Text(
          'คุณต้องการลบบันทึกนี้หรือไม่?\nการดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('ยกเลิก',
                style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteDiary(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child:
                const Text('ลบ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE
// ============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  const Color(0xFF9C7AB8).withOpacity(0.15),
                  const Color(0xFFAB8FC9).withOpacity(0.1),
                ]),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF9C7AB8).withOpacity(0.3), width: 3),
              ),
              child: const Icon(Icons.inbox_outlined, size: 72, color: Color(0xFF9C7AB8)),
            ),
            const SizedBox(height: 24),
            const Text('ยังไม่มีบันทึก',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6B4E7E))),
            const SizedBox(height: 10),
            const Text('เริ่มบันทึกความคิดของคุณได้เลย',
                style: TextStyle(fontSize: 14, color: Color(0xFF8D6E63), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}