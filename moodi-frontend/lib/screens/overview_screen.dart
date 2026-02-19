import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'mood_tracking_screen.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});
  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _entries = [];

  final Map<String, String> _moodEmojis = {
    'Happy': '😊', 'Calm': '😌', 'Neutral': '😐',
    'Sad': '😢', 'Anxious': '😰', 'Angry': '😡',
  };
  final Map<String, String> _moodThLabels = {
    'Happy': 'มีความสุข', 'Calm': 'สงบ', 'Neutral': 'ปกติ',
    'Sad': 'เศร้า', 'Anxious': 'วิตกกังวล', 'Angry': 'โกรธ',
  };
  final Map<String, Color> _moodColors = {
    'Happy': const Color(0xFFFFD93D), 'Calm': const Color(0xFF6BCB77),
    'Neutral': const Color(0xFFA8DADC), 'Sad': const Color(0xFF4D96FF),
    'Anxious': const Color(0xFF9575CD), 'Angry': const Color(0xFFFF6B6B),
  };

  double get _avgScore {
    if (_entries.isEmpty) return 0;
    final scores = _entries.map((e) => moodScoreMap[e['mood']] ?? 3);
    return scores.reduce((a, b) => a + b) / _entries.length;
  }

  Map<String, int> get _moodCounts {
    final map = <String, int>{};
    for (final e in _entries) {
      map[e['mood']] = (map[e['mood']] ?? 0) + 1;
    }
    return map;
  }

  String? get _dominantMood {
    final mc = _moodCounts;
    if (mc.isEmpty) return null;
    return mc.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  int get _positivePct {
    if (_entries.isEmpty) return 0;
    const pos = {'Happy', 'Calm', 'Neutral'};
    final count = _moodCounts.entries
        .where((e) => pos.contains(e.key))
        .fold(0, (s, e) => s + e.value);
    return ((count / _entries.length) * 100).round();
  }

  List<List<Map<String, dynamic>>> get _weekDayEntries {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final d = DateTime(start.year, start.month, start.day + i);
      return _entries.where((e) {
        final ts = e['timestamp'] as DateTime;
        return ts.year == d.year && ts.month == d.month && ts.day == d.day;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) { setState(() => _loading = false); return; }
    final data = await ApiService.getMoodByUser(userId);
    setState(() {
      _entries = data.map<Map<String, dynamic>>((item) => {
        'mood': item['mood'],
        'note': item['note'] ?? '',
        'timestamp': DateTime.parse(item['timestamp']).toUtc().add(const Duration(hours: 7)),
      }).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C4DFF)))
                  : _entries.isEmpty
                      ? _emptyState()
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          color: const Color(0xFF7C4DFF),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _scoreSection(),
                                const SizedBox(height: 20),
                                _heatmapSection(),
                                const SizedBox(height: 20),
                                _distributionSection(),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)]),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 17, color: Color(0xFF7C4DFF)),
            ),
          ),
          const SizedBox(width: 12),
          const Text('ภาพรวมอารมณ์', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF2D1B69))),
          const Spacer(),
          GestureDetector(
            onTap: _loadData,
            child: Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 8)]),
              child: const Icon(Icons.refresh_rounded, size: 19, color: Color(0xFF7C4DFF)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('📊', style: TextStyle(fontSize: 52)),
        const SizedBox(height: 12),
        const Text('ยังไม่มีข้อมูลอารมณ์', style: TextStyle(fontSize: 15, color: Color(0xFFAAAAAA))),
        const SizedBox(height: 4),
        const Text('กลับไปบันทึกอารมณ์ก่อนนะ', style: TextStyle(fontSize: 13, color: Color(0xFFCCCCCC))),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.of(context).maybePop(),
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C4DFF),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
          child: const Text('ไปบันทึกอารมณ์', style: TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _scoreSection() {
    final avg = _avgScore;
    final level = getMoodLevel(avg);
    final pct = ((avg / 5.0) * 100).clamp(0, 100).toInt();
    final dom = _dominantMood;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [level.color.withOpacity(0.75), level.color.withOpacity(0.35)],
          begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: level.color.withOpacity(0.28), blurRadius: 14, offset: const Offset(0, 5))],
      ),
      child: Column(children: [
        Row(children: [
          Stack(alignment: Alignment.center, children: [
            SizedBox(width: 80, height: 80,
              child: CircularProgressIndicator(value: avg / 5, strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white))),
            Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$pct', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, height: 1)),
              Text('%', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.8))),
            ]),
          ]),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(level.emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(level.labelTh, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.white)),
            ]),
            const SizedBox(height: 3),
            Text(level.description, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ])),
        ]),
        const SizedBox(height: 16),
        Row(children: [
          _statChip('บันทึกแล้ว', '${_entries.length} ครั้ง', Icons.edit_note_rounded),
          const SizedBox(width: 10),
          _statChip('อารมณ์ดี', '$_positivePct%', Icons.sentiment_satisfied_alt_rounded),
          if (dom != null) ...[
            const SizedBox(width: 10),
            _statChip('บ่อยสุด', _moodEmojis[dom] ?? '', Icons.star_rounded),
          ],
        ]),
      ]),
    );
  }

  Widget _statChip(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.8))),
        ]),
      ),
    );
  }

  Widget _heatmapSection() {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: now.weekday - 1));
    final dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final dayEntries = _weekDayEntries;
    final counts = dayEntries.map((e) => e.length).toList();
    final maxC = counts.reduce((a, b) => a > b ? a : b);
    final effMax = maxC < 1 ? 1 : maxC;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.grid_on_rounded, color: Color(0xFF7C4DFF), size: 20),
          SizedBox(width: 8),
          Text('บันทึกสัปดาห์นี้', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2D1B69))),
        ]),
        const SizedBox(height: 14),
        Row(
          children: List.generate(7, (i) {
            final count = counts[i];
            final intensity = count / effMax;
            final isToday = i == now.weekday - 1;
            String? emoji;
            if (dayEntries[i].isNotEmpty) {
              final mc = <String, int>{};
              for (final e in dayEntries[i]) { mc[e['mood']] = (mc[e['mood']] ?? 0) + 1; }
              final dom = mc.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
              emoji = _moodEmojis[dom];
            }
            return Expanded(
              child: GestureDetector(
                onTap: count > 0 ? () => _showDayDetail(dayEntries[i], start.add(Duration(days: i))) : null,
                child: Column(children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 52,
                    decoration: BoxDecoration(
                      color: count > 0
                          ? Color.lerp(const Color(0xFFD4C4FF), const Color(0xFF7C4DFF), intensity)
                          : const Color(0xFFEEE8FF),
                      borderRadius: BorderRadius.circular(12),
                      border: isToday ? Border.all(color: const Color(0xFF7C4DFF), width: 2) : null,
                      boxShadow: count > 0
                          ? [BoxShadow(color: const Color(0xFF7C4DFF).withOpacity(0.18 * intensity), blurRadius: 6)]
                          : null,
                    ),
                    child: Center(
                      child: count > 0
                          ? Column(mainAxisSize: MainAxisSize.min, children: [
                              if (emoji != null) Text(emoji, style: const TextStyle(fontSize: 16)),
                              Text('$count', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800,
                                color: intensity > 0.5 ? Colors.white : const Color(0xFF7C4DFF))),
                            ])
                          : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(dayLabels[i], style: TextStyle(fontSize: 11,
                    fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                    color: isToday ? const Color(0xFF7C4DFF) : const Color(0xFF9E9E9E))),
                ]),
              ),
            );
          }),
        ),
        const SizedBox(height: 14),
        Row(children: [
          Container(width: 14, height: 14,
            decoration: BoxDecoration(color: const Color(0xFFEEE8FF), borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 5),
          const Text('ไม่มีบันทึก', style: TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
          const SizedBox(width: 14),
          Container(width: 14, height: 14,
            decoration: BoxDecoration(color: const Color(0xFF7C4DFF), borderRadius: BorderRadius.circular(4))),
          const SizedBox(width: 5),
          const Text('บันทึกมาก', style: TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
          const Spacer(),
          GestureDetector(
            onTap: _showMonthHeatmap,
            child: const Text('ดูรายเดือน →', style: TextStyle(fontSize: 12, color: Color(0xFF7C4DFF), fontWeight: FontWeight.w600)),
          ),
        ]),
      ]),
    );
  }

  void _showDayDetail(List<Map<String, dynamic>> entries, DateTime date) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Text('${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2D1B69))),
            const SizedBox(height: 12),
            ...entries.map((e) {
              final c = _moodColors[e['mood']] ?? Colors.grey;
              final emoji = _moodEmojis[e['mood']] ?? '';
              final label = _moodThLabels[e['mood']] ?? e['mood'];
              final ts = e['timestamp'] as DateTime;
              final score = moodScoreMap[e['mood']] ?? 3;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(children: [
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: c, fontSize: 14)),
                    if ((e['note'] as String).isNotEmpty)
                      Text(e['note'], style: const TextStyle(fontSize: 12, color: Color(0xFF777777))),
                  ])),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('$score/5', style: TextStyle(fontWeight: FontWeight.w700, color: c)),
                    Text('${ts.hour.toString().padLeft(2,'0')}:${ts.minute.toString().padLeft(2,'0')} น.',
                      style: const TextStyle(fontSize: 11, color: Color(0xFFAAAAAA))),
                  ]),
                ]),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showMonthHeatmap() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startWeekday = firstDay.weekday - 1;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_thMonth(now.month)} ${now.year + 543}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF2D1B69))),
              const SizedBox(height: 14),
              Row(children: ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'].map((d) =>
                Expanded(child: Center(child: Text(d, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9E9E9E)))))).toList()),
              const SizedBox(height: 6),
              _monthGrid(now, daysInMonth, startWeekday),
              const SizedBox(height: 14),
              Center(child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                  decoration: BoxDecoration(color: const Color(0xFF7C4DFF), borderRadius: BorderRadius.circular(20)),
                  child: const Text('ปิด', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _monthGrid(DateTime now, int daysInMonth, int startWeekday) {
    final cells = <Widget>[];
    for (int i = 0; i < startWeekday; i++) cells.add(const SizedBox());
    for (int d = 1; d <= daysInMonth; d++) {
      final date = DateTime(now.year, now.month, d);
      final dayEntries = _entries.where((e) {
        final ts = e['timestamp'] as DateTime;
        return ts.year == date.year && ts.month == date.month && ts.day == date.day;
      }).toList();
      final hasEntry = dayEntries.isNotEmpty;
      final isToday = d == now.day;
      String? emoji;
      Color cellColor = const Color(0xFFEEE8FF);
      if (hasEntry) {
        final mc = <String, int>{};
        for (final e in dayEntries) { mc[e['mood']] = (mc[e['mood']] ?? 0) + 1; }
        final dom = mc.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
        emoji = _moodEmojis[dom];
        cellColor = (_moodColors[dom] ?? const Color(0xFF7C4DFF)).withOpacity(0.7);
      }
      cells.add(GestureDetector(
        onTap: hasEntry ? () { Navigator.pop(context); _showDayDetail(dayEntries, date); } : null,
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: cellColor, borderRadius: BorderRadius.circular(8),
            border: isToday ? Border.all(color: const Color(0xFF7C4DFF), width: 2) : null,
          ),
          child: Center(
            child: hasEntry && emoji != null
                ? Text(emoji, style: const TextStyle(fontSize: 15))
                : Text('$d', style: TextStyle(fontSize: 10,
                    fontWeight: isToday ? FontWeight.w800 : FontWeight.normal,
                    color: isToday ? const Color(0xFF7C4DFF) : const Color(0xFFCCCCCC))),
          ),
        ),
      ));
    }
    return GridView.count(crossAxisCount: 7, shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), childAspectRatio: 1, children: cells);
  }

  String _thMonth(int m) {
    const months = ['', 'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.', 'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.'];
    return months[m];
  }

  // ══════════════════════════════════════
  //  DISTRIBUTION — Donut Chart
  // ══════════════════════════════════════

  Widget _distributionSection() {
    final mc = _moodCounts;
    if (mc.isEmpty) return const SizedBox.shrink();
    final total = _entries.length;
    final sorted = mc.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final dom = _dominantMood;

    // รวบรวม data สำหรับ chart
    final chartData = sorted.map((e) => _DonutSlice(
      mood: e.key,
      count: e.value,
      pct: e.value / total,
      color: _moodColors[e.key] ?? Colors.grey,
      emoji: _moodEmojis[e.key] ?? '',
      label: _moodThLabels[e.key] ?? e.key,
    )).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──
          const Row(children: [
            Icon(Icons.donut_large_rounded, color: Color(0xFF7C4DFF), size: 20),
            SizedBox(width: 8),
            Text('สัดส่วนอารมณ์', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF2D1B69))),
          ]),

          const SizedBox(height: 24),

          // ── Donut Chart + Legend ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Chart
              SizedBox(
                width: 150,
                height: 150,
                child: Stack(alignment: Alignment.center, children: [
                  CustomPaint(
                    size: const Size(150, 150),
                    painter: _DonutChartPainter(slices: chartData),
                  ),
                  // ── ตรงกลาง: อารมณ์ที่พบบ่อยสุด ──
                  Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      dom != null ? (_moodEmojis[dom] ?? '') : '—',
                      style: const TextStyle(fontSize: 32),
                    ),
                    Text(
                      dom != null ? (_moodThLabels[dom] ?? '') : '',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF888888), fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'บ่อยสุด',
                      style: TextStyle(fontSize: 9, color: Colors.grey[400]),
                    ),
                  ]),
                ]),
              ),

              const SizedBox(width: 20),

              // Legend
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: chartData.map((slice) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(children: [
                      // สี
                      Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          color: slice.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // emoji + ชื่อ
                      Text(slice.emoji, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(slice.label,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF444444), fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // เปอร์เซ็นต์
                      Text(
                        '${(slice.pct * 100).round()}%',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: slice.color),
                      ),
                    ]),
                  )).toList(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF0ECFF)),
          const SizedBox(height: 16),

          // ── Summary bar ที่ด้านล่าง ──
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 16,
              child: Row(
                children: chartData.map((slice) => Flexible(
                  flex: (slice.pct * 1000).round(),
                  child: Tooltip(
                    message: '${slice.label} ${(slice.pct * 100).round()}%',
                    child: Container(color: slice.color),
                  ),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              'บันทึกทั้งหมด $total ครั้ง',
              style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════
//  Data model สำหรับ Donut
// ══════════════════════════════════════

class _DonutSlice {
  final String mood;
  final int count;
  final double pct;
  final Color color;
  final String emoji;
  final String label;

  const _DonutSlice({
    required this.mood,
    required this.count,
    required this.pct,
    required this.color,
    required this.emoji,
    required this.label,
  });
}

// ══════════════════════════════════════
//  CustomPainter: Donut Chart
// ══════════════════════════════════════

class _DonutChartPainter extends CustomPainter {
  final List<_DonutSlice> slices;

  const _DonutChartPainter({required this.slices});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = size.width / 2;
    final innerR = outerR * 0.54; // ความหนาวงแหวน
    final gap = 0.03; // ช่องว่างระหว่าง slice (radian)

    double startAngle = -3.14159 / 2; // เริ่มจากบน

    for (final slice in slices) {
      if (slice.pct <= 0) continue;
      final sweep = 2 * 3.14159 * slice.pct - gap;

      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      final path = Path();
      // วาด arc ด้านนอก
      final outerRect = Rect.fromCircle(center: Offset(cx, cy), radius: outerR);
      final innerRect = Rect.fromCircle(center: Offset(cx, cy), radius: innerR);

      path.arcTo(outerRect, startAngle, sweep, true);
      path.arcTo(innerRect, startAngle + sweep, -sweep, false);
      path.close();

      canvas.drawPath(path, paint);

      startAngle += sweep + gap;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPainter oldDelegate) => oldDelegate.slices != slices;
}