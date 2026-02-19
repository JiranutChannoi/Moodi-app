import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

// ─────────────────────────────────────────────
//  MOOD SCORE MAP
// ─────────────────────────────────────────────
const Map<String, int> moodScoreMap = {
  'Happy': 5,
  'Calm': 4,
  'Neutral': 3,
  'Sad': 2,
  'Anxious': 1,
  'Angry': 1,
};

// ─────────────────────────────────────────────
//  MOOD LEVEL
// ─────────────────────────────────────────────
class MoodLevel {
  final String labelTh;
  final String emoji;
  final Color color;
  final String description;
  const MoodLevel({
    required this.labelTh,
    required this.emoji,
    required this.color,
    required this.description,
  });
}

MoodLevel getMoodLevel(double avg) {
  if (avg >= 4.5) {
    return const MoodLevel(labelTh: 'ยอดเยี่ยม', emoji: '🌟', color: Color(0xFFFFD93D), description: 'อารมณ์ดีมากในช่วงนี้!');
  } else if (avg >= 3.5) {
    return const MoodLevel(labelTh: 'ดี', emoji: '😊', color: Color(0xFF6BCB77), description: 'อารมณ์อยู่ในเกณฑ์ดี');
  } else if (avg >= 2.5) {
    return const MoodLevel(labelTh: 'พอใช้', emoji: '😐', color: Color(0xFFA8DADC), description: 'ลองหากิจกรรมผ่อนคลายดูนะ');
  } else if (avg >= 1.5) {
    return const MoodLevel(labelTh: 'ต่ำ', emoji: '😢', color: Color(0xFF4D96FF), description: 'ดูแลตัวเองด้วยนะ');
  } else {
    return const MoodLevel(labelTh: 'ต้องการความช่วยเหลือ', emoji: '💙', color: Color(0xFF9575CD), description: 'ลองพูดคุยกับผู้เชี่ยวชาญ');
  }
}

// ─────────────────────────────────────────────
//  SHARED DATA MODEL  ← OverviewScreen ใช้นี้
// ─────────────────────────────────────────────
class MoodSummary {
  final double averageScore;
  final MoodLevel level;
  final int totalEntries;
  /// entries raw list — OverviewScreen จะนำไปสร้าง heatmap เอง
  final List<Map<String, dynamic>> entries;
  final Map<String, int> moodCounts;

  const MoodSummary({
    required this.averageScore,
    required this.level,
    required this.totalEntries,
    required this.entries,
    required this.moodCounts,
  });

  /// จำนวนครั้งที่บันทึกใน 7 วันนี้ (index 0 = จันทร์)
  List<int> get weeklyCount {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final day = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day + i);
      return entries.where((e) {
        final ts = e['timestamp'] as DateTime;
        return ts.year == day.year && ts.month == day.month && ts.day == day.day;
      }).length;
    });
  }
}

// ─────────────────────────────────────────────
//  SCREEN
// ─────────────────────────────────────────────
class MoodTrackingScreen extends StatefulWidget {
  final ValueChanged<MoodSummary>? onSummaryUpdated;

  const MoodTrackingScreen({super.key, this.onSummaryUpdated});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen>
    with TickerProviderStateMixin {
  int _page = 0; // 0 = บันทึก, 1 = ประวัติ
  String? selectedMood;
  final TextEditingController _noteCtrl = TextEditingController();
  final List<Map<String, dynamic>> moodEntries = [];

  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy',   'labelTh': 'มีความสุข',   'color': const Color(0xFFFFD93D)},
    {'emoji': '😌', 'label': 'Calm',    'labelTh': 'สงบ',         'color': const Color(0xFF6BCB77)},
    {'emoji': '😐', 'label': 'Neutral', 'labelTh': 'ปกติ',        'color': const Color(0xFFA8DADC)},
    {'emoji': '😢', 'label': 'Sad',     'labelTh': 'เศร้า',       'color': const Color(0xFF4D96FF)},
    {'emoji': '😰', 'label': 'Anxious', 'labelTh': 'วิตกกังวล',   'color': const Color(0xFF9575CD)},
    {'emoji': '😡', 'label': 'Angry',   'labelTh': 'โกรธ',        'color': const Color(0xFFFF6B6B)},
  ];

  // ── computed ──
  MoodSummary get _summary {
    final scores = moodEntries.map((e) => moodScoreMap[e['mood']] ?? 3).toList();
    final avg = scores.isEmpty ? 0.0 : scores.reduce((a, b) => a + b) / scores.length;
    final moodCounts = <String, int>{};
    for (final e in moodEntries) {
      final m = e['mood'] as String;
      moodCounts[m] = (moodCounts[m] ?? 0) + 1;
    }
    return MoodSummary(
      averageScore: avg,
      level: getMoodLevel(avg),
      totalEntries: moodEntries.length,
      entries: List.unmodifiable(moodEntries),
      moodCounts: moodCounts,
    );
  }

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
    _loadHistory();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // ── DB ──

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;
    final data = await ApiService.getMoodByUser(userId);
    setState(() {
      moodEntries
        ..clear()
        ..addAll(data.map<Map<String, dynamic>>((item) => {
              'mood': item['mood'],
              'note': item['note'] ?? '',
              'timestamp': DateTime.parse(item['timestamp']).toUtc().add(const Duration(hours: 7)),
            }));
    });
    widget.onSummaryUpdated?.call(_summary);
  }

  Future<void> _save() async {
    if (selectedMood == null) return;
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;
    final ok = await ApiService.createMood(userId: userId, mood: selectedMood!, note: _noteCtrl.text);
    if (ok) {
      await _loadHistory();
      setState(() { selectedMood = null; _noteCtrl.clear(); });
      _snack('บันทึกอารมณ์สำเร็จ ✓', Colors.green);
    }
  }

  Future<void> _delete(int index) async {
    setState(() => moodEntries.removeAt(index));
    widget.onSummaryUpdated?.call(_summary);
  }

  // ── helpers ──

  void _snack(String msg, Color color) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));

  void _go(int page) {
    _fadeCtrl.reset();
    setState(() => _page = page);
    _fadeCtrl.forward();
  }

  Map<String, dynamic> _moodData(String label) =>
      moods.firstWhere((m) => m['label'] == label, orElse: () => moods[2]);

  // ── BUILD ──

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: _page == 0 ? _recordPage() : _historyPage(),
        ),
      ),
    );
  }

  // ══════════════ PAGE 0 – บันทึก ══════════════

  Widget _recordPage() {
    return Column(
      children: [
        _topBar('บันทึกอารมณ์', trailing: TextButton.icon(
          onPressed: () async { await _loadHistory(); _go(1); },
          icon: const Icon(Icons.history_rounded, size: 18),
          label: const Text('ประวัติ'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C4DFF)),
        )),
        if (moodEntries.isNotEmpty) _scoreCard(),
        _weekHeatmap(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12,
            ),
            itemCount: moods.length,
            itemBuilder: (_, i) => _moodTile(moods[i]),
          ),
        ),
        _noteSection(),
      ],
    );
  }

  // ── top bar ──

  Widget _topBar(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          // ปุ่มย้อนกลับ
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)],
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Color(0xFF7C4DFF)),
            ),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2D1B69))),
          const Spacer(),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ── score card ──

  Widget _scoreCard() {
    final s = _summary;
    final pct = ((s.averageScore / 5.0) * 100).clamp(0, 100).toInt();
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [s.level.color.withOpacity(0.75), s.level.color.withOpacity(0.35)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: s.level.color.withOpacity(0.28), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 68, height: 68,
              child: CircularProgressIndicator(
                value: s.averageScore / 5,
                strokeWidth: 7,
                backgroundColor: Colors.white.withOpacity(0.35),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Text('$pct', style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white)),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(s.level.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
                Text(s.level.labelTh, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white)),
              ]),
              const SizedBox(height: 3),
              Text(s.level.description, style: const TextStyle(fontSize: 12, color: Colors.white70)),
              const SizedBox(height: 5),
              Text('บันทึกทั้งหมด ${s.totalEntries} ครั้ง',
                  style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          )),
        ],
      ),
    );
  }

  // ── weekly heatmap ──

  Widget _weekHeatmap() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final labels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final counts = List.generate(7, (i) {
      final d = DateTime(start.year, start.month, start.day + i);
      return moodEntries.where((e) {
        final ts = e['timestamp'] as DateTime;
        return ts.year == d.year && ts.month == d.month && ts.day == d.day;
      }).length;
    });
    final maxC = counts.reduce((a, b) => a > b ? a : b);
    final effMax = maxC < 1 ? 1 : maxC;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('สัปดาห์นี้', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2D1B69))),
          const SizedBox(height: 8),
          Row(
            children: List.generate(7, (i) {
              final count = counts[i];
              final intensity = count / effMax;
              final isToday = i == now.weekday - 1;
              return Expanded(
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 36,
                      decoration: BoxDecoration(
                        color: count > 0
                            ? Color.lerp(const Color(0xFFD4C4FF), const Color(0xFF7C4DFF), intensity)
                            : const Color(0xFFE8E0FF),
                        borderRadius: BorderRadius.circular(9),
                        border: isToday ? Border.all(color: const Color(0xFF7C4DFF), width: 2) : null,
                        boxShadow: count > 0 ? [BoxShadow(color: const Color(0xFF7C4DFF).withOpacity(0.18 * intensity), blurRadius: 5)] : null,
                      ),
                      child: Center(
                        child: count > 0
                            ? Text('$count', style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w800,
                                color: intensity > 0.5 ? Colors.white : const Color(0xFF7C4DFF)))
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(labels[i], style: TextStyle(
                        fontSize: 11,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                        color: isToday ? const Color(0xFF7C4DFF) : const Color(0xFF9E9E9E))),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── mood tile ──

  Widget _moodTile(Map<String, dynamic> mood) {
    final sel = selectedMood == mood['label'];
    final c = mood['color'] as Color;
    return GestureDetector(
      onTap: () => setState(() => selectedMood = mood['label']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: sel ? c.withOpacity(0.22) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: sel ? c : Colors.transparent, width: 2.5),
          boxShadow: [BoxShadow(
            color: sel ? c.withOpacity(0.28) : Colors.black.withOpacity(0.05),
            blurRadius: sel ? 12 : 6, offset: const Offset(0, 3),
          )],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood['emoji'], style: TextStyle(fontSize: sel ? 38 : 32)),
            const SizedBox(height: 4),
            Text(mood['labelTh'], style: TextStyle(
                fontSize: 12,
                fontWeight: sel ? FontWeight.w800 : FontWeight.w500,
                color: sel ? c : const Color(0xFF555555))),
          ],
        ),
      ),
    );
  }

  // ── note section ──

  Widget _noteSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Color(0x15000000), blurRadius: 16, offset: Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _noteCtrl,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'เขียนบันทึกเพิ่มเติม... (ไม่บังคับ)',
              hintStyle: const TextStyle(color: Color(0xFFBBBBBB)),
              filled: true, fillColor: const Color(0xFFF5F0FF),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedMood != null ? _save : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                disabledBackgroundColor: const Color(0xFFD0BFFF),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('บันทึกอารมณ์',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════ PAGE 1 – ประวัติ ══════════════

  Widget _historyPage() {
    final s = _summary;
    return Column(
      children: [
        _topBar('ประวัติอารมณ์', trailing: TextButton.icon(
          onPressed: () => _go(0),
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('บันทึก'),
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF7C4DFF)),
        )),
        // mini score bar
        if (moodEntries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Text(s.level.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('คะแนนเฉลี่ย ${s.averageScore.toStringAsFixed(1)}/5.0 · ${s.level.labelTh}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF2D1B69))),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: s.averageScore / 5,
                          minHeight: 6,
                          backgroundColor: const Color(0xFFEEE8FF),
                          valueColor: AlwaysStoppedAnimation<Color>(s.level.color),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
        // count
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text('${moodEntries.length} รายการ', style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
          ),
        ),
        Expanded(
          child: moodEntries.isEmpty
              ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('📭', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 12),
                  Text('ยังไม่มีการบันทึก', style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 15)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: moodEntries.length,
                  itemBuilder: (_, i) {
                    final entry = moodEntries[i];
                    final mood = _moodData(entry['mood']);
                    return _historyCard(entry, mood, i);
                  },
                ),
        ),
      ],
    );
  }

  Widget _historyCard(Map<String, dynamic> entry, Map<String, dynamic> mood, int index) {
    final c = mood['color'] as Color;
    final score = moodScoreMap[mood['label']] ?? 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(color: c.withOpacity(0.15), shape: BoxShape.circle),
              child: Center(child: Text(mood['emoji'], style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(mood['labelTh'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: c)),
              Text(_fmt(entry['timestamp']), style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: c.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
              child: Text('$score/5', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: c)),
            ),
            IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFFCCCCCC)),
              onPressed: () => _confirmDelete(index),
              padding: EdgeInsets.zero, constraints: const BoxConstraints(),
            ),
          ]),
          if ((entry['note'] as String).isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF5F0FF), borderRadius: BorderRadius.circular(10)),
              child: Text(entry['note'], style: const TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.4)),
            ),
          ],
        ]),
      ),
    );
  }

  String _fmt(DateTime d) =>
      '${d.day}/${d.month}/${d.year}  ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} น.';

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('ลบรายการนี้?'),
        content: const Text('ต้องการลบข้อมูลอารมณ์นี้ออกจากประวัติ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () { Navigator.pop(context); _delete(index); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('ลบ', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}