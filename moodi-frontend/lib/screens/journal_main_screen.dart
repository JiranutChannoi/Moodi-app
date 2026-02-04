import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// ============================================================================
// JOURNAL MAIN SCREEN - หน้าหลักของสมุดสะท้อนความคิด
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

  TextEditingController thoughtsController = TextEditingController();
  TextEditingController actionsController = TextEditingController();

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

  Widget _buildHeader(BuildContext context) {
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
                      color: const Color(0xFF9C7AB8).withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF7B5A96),
                  size: 20,
                ),
              ),
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JournalHistoryScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
                  ),
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
                    Text(
                      'ประวัติ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                    // เงาพื้นหลัง
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
                    // กระดาษด้านหลัง (เหลือง)
                    Positioned(
                      right: 25,
                      top: 35,
                      child: Transform.rotate(
                        angle: 0.12,
                        child: Container(
                          width: 85,
                          height: 95,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD93D).withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 18,
                                left: 12,
                                right: 12,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 28,
                                left: 12,
                                right: 20,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 38,
                                left: 12,
                                right: 15,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // กระดาษหลัก (ชมพู)
                    Positioned(
                      top: 30,
                      child: Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9AA2).withOpacity(0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 18,
                              left: 14,
                              right: 14,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 28,
                              left: 14,
                              right: 22,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 38,
                              left: 14,
                              right: 18,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 12,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: const Text('💡', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    // ประกายแสง
                    Positioned(
                      top: 15,
                      right: 35,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.7),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 40,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 22,
                      left: 30,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
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
        },
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'สมุดสะท้อนความคิด',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B4E7E),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMotivationalText() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9E6), Color(0xFFFFFDF5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFE082).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFCA28)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD54F).withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'บันทึกความคิดของคุณ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4E7E),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'เขียนสะท้อนวันนี้ เพื่อเข้าใจตัวเองมากขึ้น',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8D6E63),
                    height: 1.4,
                  ),
                ),
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
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF6B4E7E),
        fontWeight: FontWeight.bold,
        letterSpacing: 0.3,
      ),
    );
  }

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
            child: _buildIssueChip(
              issues[index]['label'],
              issues[index]['selected'],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIssueChip(String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB8D4F1), Color(0xFFCCE2F7)],
              )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? const Color(0xFFB8D4F1).withOpacity(0.6)
              : const Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: const Color(0xFFB8D4F1).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? const Color(0xFF4A6FA5) : const Color(0xFF7B5A96),
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildSelectedIssue() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F4F8), Color(0xFFF5FAFC)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFB8D4F1).withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8D4F1).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF90B8E8), Color(0xFFADCBEE)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF90B8E8).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.event_note, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'เหตุการณ์ : $selectedIssue',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A6FA5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            child: _buildFeelingChip(
              feeling['emoji'],
              feeling['label'],
              feeling['selected'],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeelingChip(String emoji, String label, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)],
              )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? const Color(0xFFD4B5E8).withOpacity(0.6)
              : const Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: const Color(0xFFD4B5E8).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected ? const Color(0xFF7B5A96) : const Color(0xFF6B6B6B),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThoughtsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4B5E8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Text(
              'ความรู้สึก : $selectedFeeling',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B4E7E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'แนวทางที่ใช้จัดการปัญหา',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B4E7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C7AB8).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: thoughtsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'อธิบายวิธีที่คุณใช้จัดการกับสถานการณ์ที่เกิดขึ้น......',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'สิ่งที่เรียนรู้ หรืออยากทำให้ดีขึ้นในอนาคต',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B4E7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C7AB8).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: actionsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'เขียนสิ่งที่คุณได้รับหรือต้องการปรับปรุงในอนาคต.....',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B6B6B),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          if (thoughtsController.text.isEmpty || actionsController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                backgroundColor: Color(0xFFFF9AA2),
              ),
            );
            return;
          }

          final prefs = await SharedPreferences.getInstance();
          final userId = prefs.getInt('user_id');

          if (userId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('กรุณาเข้าสู่ระบบใหม่')),
            );
            return;
          }

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

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('บันทึกความคิดเรียบร้อยแล้ว'),
                backgroundColor: Color(0xFF66BB6A),
              ),
            );
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('บันทึกไม่สำเร็จ'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF66BB6A).withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark, color: Colors.white, size: 24),
              SizedBox(width: 10),
              Text(
                'บันทึกความคิด',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// JOURNAL HISTORY SCREEN - หน้าประวัติบันทึก
// ============================================================================

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen>
    with SingleTickerProviderStateMixin {
  // ✅ State ที่ถูกต้อง - อยู่ใน State class
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

    // ✅ เรียกโหลดข้อมูลจาก Database
    _loadDiaryFromDb();
  }

  // ✅ ฟังก์ชันโหลดข้อมูลจาก Database - อยู่ใน State class
  Future<void> _loadDiaryFromDb() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final data = await ApiService.getDiaryByUser(userId);

    setState(() {
      diaryEntries = data.map<Map<String, dynamic>>((e) {
        return {
          'date': e['created_at'] ?? '',
          'issue': e['event'] ?? '',
          'feeling': e['mood'] ?? '',
          'thoughts': e['solution'] ?? '',
          'actions': e['improve'] ?? '',
          'id': e['entry_id'], // เก็บ ID ไว้สำหรับลบ
        };
      }).toList();

      isLoading = false;
    });
  }

  // ✅ ฟังก์ชันลบข้อมูลจาก Database
  Future<void> _deleteDiaryEntry(int index) async {
  final entryId = diaryEntries[index]['id'];

  final success = await ApiService.deleteDiary(entryId);

  if (success) {
    setState(() {
      diaryEntries.removeAt(index);
    });
  } else {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ลบไม่สำเร็จ'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  void dispose() {
    _animationController.dispose();
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
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF9C7AB8),
                        ),
                      )
                    : SingleChildScrollView(
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
                            diaryEntries.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 60),
                                    child: _EmptyState(),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    itemCount: diaryEntries.length,
                                    itemBuilder: (context, index) {
                                      return _buildEnhancedJournalCard(
                                        diaryEntries[index],
                                        index,
                                      );
                                    },
                                  ),
                            const SizedBox(height: 20),
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

  Widget _buildHeader(BuildContext context) {
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
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF7B5A96),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                    // เงาพื้นหลัง
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
                    // กระดาษด้านหลัง (เหลือง)
                    Positioned(
                      right: 25,
                      top: 35,
                      child: Transform.rotate(
                        angle: 0.12,
                        child: Container(
                          width: 85,
                          height: 95,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD93D).withOpacity(0.35),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 18,
                                left: 12,
                                right: 12,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 28,
                                left: 12,
                                right: 20,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 38,
                                left: 12,
                                right: 15,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // กระดาษหลัก (ชมพู)
                    Positioned(
                      top: 30,
                      child: Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9AA2).withOpacity(0.45),
                              blurRadius: 22,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 18,
                              left: 14,
                              right: 14,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 28,
                              left: 14,
                              right: 22,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 38,
                              left: 14,
                              right: 18,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 12,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: const Text('💡', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    // ประกายแสง
                    Positioned(
                      top: 15,
                      right: 35,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.7),
                              blurRadius: 12,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 40,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 22,
                      left: 30,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEB3B).withOpacity(0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFEB3B).withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
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
        },
      ),
    );
  }

  Widget _buildTitle() {
    return const Center(
      child: Text(
        'สมุดสะท้อนความคิด',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6B4E7E),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubtitle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFFFD54F).withOpacity(0.2),
              const Color(0xFFFFCA28).withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'ย้อนดูความคิดและการเติบโตของคุณ',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF8D6E63),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE8D5F0).withOpacity(0.5),
            const Color(0xFFD4E9F7).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD4B5E8).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4B5E8).withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF9C7AB8), Color(0xFFAB8FC9)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9C7AB8).withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.history_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ประวัติบันทึก',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B4E7E),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'บันทึกทั้งหมดของคุณ',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8D6E63)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB3BA), Color(0xFFFF9AA2)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9AA2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '${diaryEntries.length}', // ✅ ใช้ diaryEntries แทน JournalData
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedJournalCard(Map<String, dynamic> entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9C7AB8).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and delete button
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry['date'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B4E7E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFEF5350),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF0F0F0), thickness: 1),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSimpleInfoRow(
                  'เหตุการณ์',
                  entry['issue'],
                  const Color(0xFFF5F5F5),
                ),
                const SizedBox(height: 10),
                _buildSimpleInfoRow(
                  'ความรู้สึกที่เกิดขึ้น',
                  entry['feeling'],
                  const Color(0xFFF5F5F5),
                ),
                const SizedBox(height: 12),
                _buildSimpleTextSection(
                  'แนวทางที่ใช้จัดการปัญหา',
                  entry['thoughts'],
                ),
                const SizedBox(height: 10),
                _buildSimpleTextSection(
                  'สิ่งที่เรียนรู้ หรืออยากทำให้ดีขึ้นในอนาคต',
                  entry['actions'],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfoRow(String label, String value, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
                children: [
                  TextSpan(
                    text: '$label : ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4E7E),
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleTextSection(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B4E7E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF424242),
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

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
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF5350).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Text(
              'ลบบันทึก',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4E7E),
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: const Text(
          'คุณต้องการลบบันทึกนี้หรือไม่?\nการดำเนินการนี้ไม่สามารถย้อนกลับได้',
          style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // ✅ ลบข้อมูลจาก Database
              await _deleteDiaryEntry(index);
              
              if (!mounted) return;
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'ลบบันทึกเรียบร้อยแล้ว',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFEF5350),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
              shadowColor: const Color(0xFFEF5350).withOpacity(0.5),
            ),
            child: const Text(
              'ลบ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE WIDGET - แสดงเมื่อไม่มีบันทึก
// ============================================================================

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF9C7AB8).withOpacity(0.15),
                  const Color(0xFFAB8FC9).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF9C7AB8).withOpacity(0.3),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 72,
              color: Color(0xFF9C7AB8),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'ยังไม่มีบันทึก',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4E7E),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'เริ่มบันทึกความคิดของคุณได้เลย',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8D6E63),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}