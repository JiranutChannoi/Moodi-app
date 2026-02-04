import 'package:flutter/material.dart';

// ============================================================================
// JOURNAL MAIN SCREEN - หน้าหลักของสมุดสะท้อนความคิด (ปรับปรุงใหม่)
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
      duration: Duration(milliseconds: 2000),
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
        decoration: BoxDecoration(
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
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIllustration(),
                        SizedBox(height: 20),
                        _buildTitle(),
                        SizedBox(height: 12),
                        _buildMotivationalText(),
                        SizedBox(height: 24),
                        _buildSubtitle('เหตุการณ์ที่เกิดขึ้น'),
                        SizedBox(height: 12),
                        _buildIssuesGrid(),
                        SizedBox(height: 20),
                        _buildSelectedIssue(),
                        SizedBox(height: 16),
                        _buildSubtitle('ความรู้สึกที่เกิดขึ้น'),
                        SizedBox(height: 12),
                        _buildFeelingsGrid(),
                        SizedBox(height: 20),
                        _buildThoughtsSection(),
                        SizedBox(height: 16),
                        _buildActionsSection(),
                        SizedBox(height: 24),
                        _buildSaveButton(),
                        SizedBox(height: 20),
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
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9C7AB8).withOpacity(0.2),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFF7B5A96),
                  size: 20,
                ),
              ),
            ),
          ),
          Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalHistoryScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF81C784).withOpacity(0.35),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
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
              child: Container(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // เงาพื้นหลัง - ปรับให้อยู่ต่ำกว่าและมีขนาดใหญ่ขึ้น
                    Positioned(
                      bottom: 5,
                      child: Container(
                        width: 120,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Color(0xFF9C7AB8).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9C7AB8).withOpacity(0.2),
                              blurRadius: 25,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // กระดาษด้านหลัง (เหลือง) - ปรับขนาดและตำแหน่ง
                    Positioned(
                      right: 25,
                      top: 35,
                      child: Transform.rotate(
                        angle: 0.12,
                        child: Container(
                          width: 85,
                          height: 95,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFFD93D).withOpacity(0.35),
                                blurRadius: 18,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // เส้นบนกระดาษเหลือง
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
                    // กระดาษหลัก (ชมพู) - ปรับขนาดให้สมดุล
                    Positioned(
                      top: 30,
                      child: Container(
                        width: 90,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF9AA2).withOpacity(0.45),
                              blurRadius: 22,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // เส้นบนกระดาษชมพู
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
                    // หลอดไฟ - ปรับขนาดให้สมดุลกับกระดาษ
                    Positioned(
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFD93D).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 6,
                              offset: Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 12,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Text('💡', style: TextStyle(fontSize: 40)),
                      ),
                    ),
                    // ประกายแสง - ปรับตำแหน่งให้สมดุล
                    Positioned(
                      top: 15,
                      right: 35,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFEB3B).withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.7),
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
                          color: Color(0xFFFFEB3B).withOpacity(0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.5),
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
                          color: Color(0xFFFFEB3B).withOpacity(0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.4),
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
    return Center(
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
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9E6), Color(0xFFFFFDF5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFFFE082).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFFD54F).withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFCA28)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFFD54F).withOpacity(0.35),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          SizedBox(width: 14),
          Expanded(
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
      style: TextStyle(
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
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFB8D4F1), Color(0xFFCCE2F7)],
              )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? Color(0xFFB8D4F1).withOpacity(0.6)
              : Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: Color(0xFFB8D4F1).withOpacity(0.35),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: selected ? Color(0xFF4A6FA5) : Color(0xFF7B5A96),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8F4F8), Color(0xFFF5FAFC)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Color(0xFFB8D4F1).withOpacity(0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFB8D4F1).withOpacity(0.25),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF90B8E8), Color(0xFFADCBEE)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF90B8E8).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.event_note, color: Colors.white, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'เหตุการณ์ : $selectedIssue',
              style: TextStyle(
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      decoration: BoxDecoration(
        gradient: selected
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)],
              )
            : null,
        color: selected ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? Color(0xFFD4B5E8).withOpacity(0.6)
              : Color(0xFFE0E0E0),
          width: 2,
        ),
        boxShadow: [
          if (selected)
            BoxShadow(
              color: Color(0xFFD4B5E8).withOpacity(0.35),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: 18)),
          SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected ? Color(0xFF7B5A96) : Color(0xFF6B6B6B),
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
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFD4B5E8), Color(0xFFE3CBF1)],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFD4B5E8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.psychology, color: Colors.white, size: 18),
            ),
            SizedBox(width: 8),
            Text(
              'ความรู้สึก : $selectedFeeling',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B4E7E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Text(
          'แนวทางที่ใช้จัดการปัญหา',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B4E7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Color(0xFFE0E0E0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9C7AB8).withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: thoughtsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText:
                  'อธิบายวิธีที่คุณใช้จัดการกับสถานการณ์ที่เกิดขึ้น......',
              hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(
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
        Text(
          'สิ่งที่เรียนรู้ หรืออยากทำให้ดีขึ้นในอนาคต',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B4E7E),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Color(0xFFE0E0E0), width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF9C7AB8).withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
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
              contentPadding: EdgeInsets.all(16),
            ),
            style: TextStyle(
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
        onTap: () {
          if (thoughtsController.text.isEmpty ||
              actionsController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                backgroundColor: Color(0xFFFF9AA2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else {
            JournalData.addEntry({
              'date': _getCurrentDate(),
              'issue': selectedIssue,
              'feeling': selectedFeeling,
              'thoughts': thoughtsController.text,
              'actions': actionsController.text,
            });

            thoughtsController.clear();
            actionsController.clear();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 10),
                    Text('บันทึกความคิดเรียบร้อยแล้ว'),
                  ],
                ),
                backgroundColor: Color(0xFF66BB6A),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF81C784)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF66BB6A).withOpacity(0.5),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
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

  String _getCurrentDate() {
    final now = DateTime.now();
    final weekdays = [
      'จันทร์',
      'อังคาร',
      'พุธ',
      'พฤหัสบดี',
      'ศุกร์',
      'เสาร์',
      'อาทิตย์',
    ];
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
    return 'วัน${weekdays[now.weekday - 1]} ที่ ${now.day} ${months[now.month - 1]} ${now.year + 543}';
  }
}

// ============================================================================
// JOURNAL DATA - เก็บข้อมูลบันทึก
// ============================================================================

class JournalData {
  static List<Map<String, dynamic>> entries = [];

  static void addEntry(Map<String, dynamic> entry) {
    entries.insert(0, entry);
  }

  static void removeEntry(Map<String, dynamic> entry) {
    entries.remove(entry);
  }
}

// ============================================================================
// JOURNAL HISTORY SCREEN - หน้าประวัติบันทึก (ปรับปรุงใหม่ - เน้นการ์ดสวยขึ้น)
// ============================================================================

class JournalHistoryScreen extends StatefulWidget {
  const JournalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<JournalHistoryScreen> createState() => _JournalHistoryScreenState();
}

class _JournalHistoryScreenState extends State<JournalHistoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 30), // เพิ่ม space ด้านบน
                      _buildIllustration(),
                      SizedBox(height: 20),
                      _buildTitle(),
                      SizedBox(height: 8),
                      _buildSubtitle(),
                      SizedBox(height: 24),
                      _buildHistoryHeader(),
                      SizedBox(height: 16),
                      JournalData.entries.isEmpty
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 60),
                              child: _buildEmptyState(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: JournalData.entries.length,
                              itemBuilder: (context, index) {
                                return _buildEnhancedJournalCard(
                                  JournalData.entries[index],
                                  index,
                                );
                              },
                            ),
                      SizedBox(height: 20),
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
      padding: EdgeInsets.all(16),
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
                      color: Color(0xFF9C7AB8).withOpacity(0.25),
                      blurRadius: 16,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
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
              child: Container(
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
                          color: Color(0xFF9C7AB8).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF9C7AB8).withOpacity(0.2),
                              blurRadius: 25,
                              offset: Offset(0, 6),
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
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFE5B4), Color(0xFFFFF4D6)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFFD93D).withOpacity(0.35),
                                blurRadius: 18,
                                offset: Offset(0, 8),
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
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFFF9AA2), Color(0xFFFFB3BA)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFF9AA2).withOpacity(0.45),
                              blurRadius: 22,
                              offset: Offset(0, 10),
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
                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFD93D).withOpacity(0.6),
                              blurRadius: 25,
                              spreadRadius: 6,
                              offset: Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 12,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: Text('💡', style: TextStyle(fontSize: 40)),
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
                          color: Color(0xFFFFEB3B).withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.7),
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
                          color: Color(0xFFFFEB3B).withOpacity(0.7),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.5),
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
                          color: Color(0xFFFFEB3B).withOpacity(0.6),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFEB3B).withOpacity(0.4),
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
    return Center(
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD54F).withOpacity(0.2),
              Color(0xFFFFCA28).withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
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
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE8D5F0).withOpacity(0.5),
            Color(0xFFD4E9F7).withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFD4B5E8).withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFD4B5E8).withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9C7AB8), Color(0xFFAB8FC9)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF9C7AB8).withOpacity(0.35),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.history_rounded, color: Colors.white, size: 24),
          ),
          SizedBox(width: 14),
          Expanded(
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
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFB3BA), Color(0xFFFF9AA2)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF9AA2).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              '${JournalData.entries.length}',
              style: TextStyle(
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF9C7AB8).withOpacity(0.15),
                  Color(0xFFAB8FC9).withOpacity(0.1),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF9C7AB8).withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 72,
              color: Color(0xFF9C7AB8),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'ยังไม่มีบันทึก',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B4E7E),
            ),
          ),
          SizedBox(height: 10),
          Text(
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

  // การ์ดแบบเรียบง่าย สบายตา
  Widget _buildEnhancedJournalCard(Map<String, dynamic> entry, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFE0E0E0), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF9C7AB8).withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and delete button
          Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry['date'],
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B4E7E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showDeleteDialog(entry),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
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
          Divider(height: 1, color: Color(0xFFF0F0F0), thickness: 1),
          // Content
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSimpleInfoRow(
                  'เหตุการณ์',
                  entry['issue'],
                  Color(0xFFF5F5F5),
                ),
                SizedBox(height: 10),
                _buildSimpleInfoRow(
                  'ความรู้สึกที่เกิดขึ้น',
                  entry['feeling'],
                  Color(0xFFF5F5F5),
                ),
                SizedBox(height: 12),
                _buildSimpleTextSection(
                  'แนวทางที่ใช้จัดการปัญหา',
                  entry['thoughts'],
                ),
                SizedBox(height: 10),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13, color: Color(0xFF6B6B6B)),
                children: [
                  TextSpan(
                    text: '$label : ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B4E7E),
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
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
          padding: EdgeInsets.only(bottom: 6),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B4E7E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
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

  void _showDeleteDialog(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFEF5350).withOpacity(0.4),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            SizedBox(width: 14),
            Text(
              'ลบบันทึก',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4E7E),
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Text(
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
            onPressed: () {
              setState(() {
                JournalData.removeEntry(entry);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Text(
                        'ลบบันทึกเรียบร้อยแล้ว',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  backgroundColor: Color(0xFFEF5350),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: EdgeInsets.all(16),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFEF5350),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              elevation: 4,
              shadowColor: Color(0xFFEF5350).withOpacity(0.5),
            ),
            child: Text(
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
