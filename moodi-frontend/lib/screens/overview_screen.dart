import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({Key? key}) : super(key: key);

  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with TickerProviderStateMixin {
  String selectedView = 'week'; // 'week' หรือ 'month'
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // ข้อมูลอารมณ์ (Mock data - จะเปลี่ยนเป็นดึงจากฐานข้อมูลจริง)
  Map<DateTime, Map<String, dynamic>> moodHistory = {};

  // สีของแต่ละอารมณ์
  final Map<String, Color> moodColors = {
    'มีความสุขมาก': Color(0xFFFFD54F), // เหลืองสดใส
    'มีความสุข': Color(0xFFFFE082),
    'ปกติ': Color(0xFF81C784), // เขียว
    'เศร้า': Color(0xFF64B5F6), // ฟ้า
    'เศร้ามาก': Color(0xFF5E35B1), // ม่วงเข้ม
    'โกรธ': Color(0xFFEF5350), // แดง
    'วิตกกังวล': Color(0xFFFF9800), // ส้ม
    'เครียด': Color(0xFFE57373),
  };

  final Map<String, String> moodEmojis = {
    'มีความสุขมาก': '😄',
    'มีความสุข': '🙂',
    'ปกติ': '😐',
    'เศร้า': '😔',
    'เศร้ามาก': '😢',
    'โกรธ': '😠',
    'วิตกกังวล': '😰',
    'เครียด': '😫',
  };

  @override
  void initState() {
    super.initState();
    _generateMockData();

    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
  }

  // สร้างข้อมูลตัวอย่าง (Mock Data)
  void _generateMockData() {
    final random = Random();
    final moods = moodColors.keys.toList();
    final now = DateTime.now();

    // สร้างข้อมูล 60 วันย้อนหลัง
    for (int i = 0; i < 60; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);

      // สุ่มว่าวันนี้มีบันทึกหรือไม่ (80% มีบันทึก)
      if (random.nextDouble() > 0.2) {
        moodHistory[dateKey] = {
          'mood': moods[random.nextInt(moods.length)],
          'note': 'บันทึกความรู้สึกประจำวัน',
          'time': TimeOfDay(
            hour: 8 + random.nextInt(14),
            minute: random.nextInt(60),
          ),
        };
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
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
            colors: [Color(0xFFF3E5F5), Color(0xFFE1F5FE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildViewSelector(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildMoodSummaryCard(),
                        SizedBox(height: 20),
                        _buildHeatmapCard(),
                        SizedBox(height: 20),
                        _buildMoodDistributionCard(),
                        SizedBox(height: 20),
                        _buildInsightsCard(),
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

  // Header
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF6A1B9A)),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ภาพรวมอารมณ์',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              Text(
                'สรุปความรู้สึกของคุณ',
                style: TextStyle(fontSize: 14, color: Color(0xFF9C27B0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ตัวเลือกมุมมอง (สัปดาห์/เดือน)
  Widget _buildViewSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildViewButton(
              'รายสัปดาห์',
              'week',
              Icons.view_week_rounded,
            ),
          ),
          Expanded(
            child: _buildViewButton(
              'รายเดือน',
              'month',
              Icons.calendar_month_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewButton(String title, String view, IconData icon) {
    final isSelected = selectedView == view;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedView = view;
          _fadeController.reset();
          _fadeController.forward();
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)])
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFF9E9E9E),
              size: 20,
            ),
            SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // การ์ดสรุปอารมณ์โดยรวม
  Widget _buildMoodSummaryCard() {
    final summary = _calculateMoodSummary();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'สรุปอารมณ์${selectedView == 'week' ? 'สัปดาห์นี้' : 'เดือนนี้'}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'บันทึกแล้ว',
                  '${summary['totalDays']} วัน',
                  Icons.edit_calendar_rounded,
                  Color(0xFF42A5F5),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildSummaryItem(
                  'อารมณ์ดี',
                  '${summary['goodMoodPercentage']}%',
                  Icons.sentiment_satisfied_rounded,
                  Color(0xFF66BB6A),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: summary['dominantColor'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: summary['dominantColor'].withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Text(summary['dominantEmoji'], style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'อารมณ์ที่พบบ่อยที่สุด',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF78909C),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        summary['dominantMood'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F),
            ),
          ),
          SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: Color(0xFF78909C))),
        ],
      ),
    );
  }

  // การ์ด Heatmap
  Widget _buildHeatmapCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          Row(
            children: [
              Icon(Icons.grid_on_rounded, color: Color(0xFF9C27B0), size: 22),
              SizedBox(width: 8),
              Text(
                'ตารางบันทึกอารมณ์',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildHeatmap(),
          SizedBox(height: 16),
          _buildHeatmapLegend(),
        ],
      ),
    );
  }

  // สร้าง Heatmap
  Widget _buildHeatmap() {
    if (selectedView == 'week') {
      return _buildWeeklyHeatmap();
    } else {
      return _buildMonthlyHeatmap();
    }
  }

  // Heatmap รายสัปดาห์
  Widget _buildWeeklyHeatmap() {
    final now = DateTime.now();
    final weekDays = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
    final weeks = <List<DateTime>>[];

    // สร้าง 4 สัปดาห์ย้อนหลัง
    for (int week = 0; week < 4; week++) {
      final weekDates = <DateTime>[];
      for (int day = 0; day < 7; day++) {
        final date = now.subtract(Duration(days: (3 - week) * 7 + (6 - day)));
        weekDates.add(DateTime(date.year, date.month, date.day));
      }
      weeks.add(weekDates);
    }

    return Column(
      children: [
        // Header วันในสัปดาห์
        Row(
          children: [
            SizedBox(width: 40), // เว้นที่สำหรับ label สัปดาห์
            ...weekDays.map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF78909C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        // Heatmap cells
        ...weeks.asMap().entries.map((entry) {
          final weekIndex = entry.key;
          final weekDates = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Text(
                    'ส.${4 - weekIndex}',
                    style: TextStyle(fontSize: 11, color: Color(0xFF9E9E9E)),
                  ),
                ),
                ...weekDates.map(
                  (date) => Expanded(child: _buildHeatmapCell(date)),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Heatmap รายเดือน
  Widget _buildMonthlyHeatmap() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    final weeks = <List<DateTime?>>[];
    var currentWeek = <DateTime?>[];

    // เติมช่องว่างต้นสัปดาห์
    for (int i = 0; i < startWeekday; i++) {
      currentWeek.add(null);
    }

    // เติมวันที่ในเดือน
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(DateTime(now.year, now.month, day));
      if (currentWeek.length == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    // เติมช่องว่างท้ายสัปดาห์
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      weeks.add(currentWeek);
    }

    final weekDays = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

    return Column(
      children: [
        // Header
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            DateFormat('MMMM yyyy', 'th').format(now),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6A1B9A),
            ),
          ),
        ),
        // วันในสัปดาห์
        Row(
          children: weekDays
              .map(
                (day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF78909C),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 8),
        // Heatmap cells
        ...weeks.map(
          (week) => Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Row(
              children: week
                  .map(
                    (date) => Expanded(
                      child: date != null
                          ? _buildHeatmapCell(date)
                          : SizedBox(height: 36),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Cell ของ Heatmap
  Widget _buildHeatmapCell(DateTime date) {
    final mood = moodHistory[date];
    final hasData = mood != null;
    final color = hasData
        ? moodColors[mood['mood']] ?? Colors.grey
        : Colors.grey[200];
    final isToday =
        date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    return GestureDetector(
      onTap: hasData
          ? () {
              _showMoodDetail(date, mood);
            }
          : null,
      child: Container(
        margin: EdgeInsets.all(2),
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: isToday
              ? Border.all(color: Color(0xFF6A1B9A), width: 2.5)
              : Border.all(color: Colors.white, width: 1),
          boxShadow: hasData
              ? [
                  BoxShadow(
                    color: color!.withOpacity(0.4),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
              color: hasData ? Colors.white : Color(0xFFBDBDBD),
            ),
          ),
        ),
      ),
    );
  }

  // Legend ของ Heatmap
  Widget _buildHeatmapLegend() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'คำอธิบาย',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF78909C),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: moodColors.entries.take(6).map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: entry.value,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    entry.key,
                    style: TextStyle(fontSize: 11, color: Color(0xFF78909C)),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // การ์ดการกระจายของอารมณ์
  Widget _buildMoodDistributionCard() {
    final distribution = _calculateMoodDistribution();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
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
          Row(
            children: [
              Icon(Icons.pie_chart_rounded, color: Color(0xFF9C27B0), size: 22),
              SizedBox(width: 8),
              Text(
                'สัดส่วนอารมณ์',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...distribution.entries.map((entry) {
            return _buildMoodBar(
              entry.key,
              entry.value['count'],
              entry.value['percentage'],
              moodColors[entry.key] ?? Colors.grey,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMoodBar(String mood, int count, double percentage, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(moodEmojis[mood] ?? '', style: TextStyle(fontSize: 18)),
                  SizedBox(width: 8),
                  Text(
                    mood,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF37474F),
                    ),
                  ),
                ],
              ),
              Text(
                '${percentage.toStringAsFixed(0)}% ($count วัน)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF78909C),
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // การ์ด Insights
  Widget _buildInsightsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF03A9F4).withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.lightbulb_rounded,
                  color: Color(0xFFFFB300),
                  size: 22,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'ข้อสังเกต',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01579B),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildInsightItem(
            Icons.trending_up_rounded,
            'คุณบันทึกความรู้สึกสม่ำเสมอมากขึ้น',
            Color(0xFF66BB6A),
          ),
          SizedBox(height: 12),
          _buildInsightItem(
            Icons.wb_sunny_rounded,
            'อารมณ์ดีมากในช่วงเช้า',
            Color(0xFFFFB300),
          ),
          SizedBox(height: 12),
          _buildInsightItem(
            Icons.self_improvement_rounded,
            'ลองทำกิจกรรมผ่อนคลายเมื่อรู้สึกเครียด',
            Color(0xFFBA68C8),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF37474F),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  // คำนวณสรุปอารมณ์
  Map<String, dynamic> _calculateMoodSummary() {
    final now = DateTime.now();
    final startDate = selectedView == 'week'
        ? now.subtract(Duration(days: 7))
        : DateTime(now.year, now.month, 1);

    final relevantMoods = moodHistory.entries.where((entry) {
      return entry.key.isAfter(startDate) ||
          entry.key.isAtSameMomentAs(startDate);
    });

    final totalDays = relevantMoods.length;
    final goodMoods = ['มีความสุขมาก', 'มีความสุข', 'ปกติ'];
    final goodMoodCount = relevantMoods
        .where((entry) => goodMoods.contains(entry.value['mood']))
        .length;

    // หาอารมณ์ที่พบบ่อยที่สุด
    final moodCount = <String, int>{};
    for (var entry in relevantMoods) {
      final mood = entry.value['mood'] as String;
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    String dominantMood = 'ปกติ';
    int maxCount = 0;
    moodCount.forEach((mood, count) {
      if (count > maxCount) {
        maxCount = count;
        dominantMood = mood;
      }
    });

    return {
      'totalDays': totalDays,
      'goodMoodPercentage': totalDays > 0
          ? ((goodMoodCount / totalDays) * 100).toInt()
          : 0,
      'dominantMood': dominantMood,
      'dominantEmoji': moodEmojis[dominantMood] ?? '😐',
      'dominantColor': moodColors[dominantMood] ?? Colors.grey,
    };
  }

  // คำนวณการกระจายของอารมณ์
  Map<String, Map<String, dynamic>> _calculateMoodDistribution() {
    final now = DateTime.now();
    final startDate = selectedView == 'week'
        ? now.subtract(Duration(days: 7))
        : DateTime(now.year, now.month, 1);

    final relevantMoods = moodHistory.entries.where((entry) {
      return entry.key.isAfter(startDate) ||
          entry.key.isAtSameMomentAs(startDate);
    });

    final totalDays = relevantMoods.length;
    final moodCount = <String, int>{};

    for (var entry in relevantMoods) {
      final mood = entry.value['mood'] as String;
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    final distribution = <String, Map<String, dynamic>>{};
    moodCount.forEach((mood, count) {
      distribution[mood] = {
        'count': count,
        'percentage': totalDays > 0 ? (count / totalDays) * 100 : 0,
      };
    });

    // เรียงจากมากไปน้อย
    final sortedEntries = distribution.entries.toList()
      ..sort((a, b) => b.value['count'].compareTo(a.value['count']));

    return Map.fromEntries(sortedEntries);
  }

  // แสดงรายละเอียดอารมณ์
  void _showMoodDetail(DateTime date, Map<String, dynamic> mood) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                moodColors[mood['mood']]!.withOpacity(0.1),
                Colors.white,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moodEmojis[mood['mood']] ?? '',
                style: TextStyle(fontSize: 48),
              ),
              SizedBox(height: 12),
              Text(
                mood['mood'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF37474F),
                ),
              ),
              SizedBox(height: 8),
              Text(
                DateFormat('d MMMM yyyy', 'th').format(date),
                style: TextStyle(fontSize: 14, color: Color(0xFF78909C)),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 18,
                      color: Color(0xFF78909C),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'เวลา: ${mood['time'].hour.toString().padLeft(2, '0')}:${mood['time'].minute.toString().padLeft(2, '0')} น.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF37474F)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: moodColors[mood['mood']],
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'ปิด',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
}
