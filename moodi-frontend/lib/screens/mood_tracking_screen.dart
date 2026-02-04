import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  int currentStep = 0;
  String? selectedMood;
  final TextEditingController noteController = TextEditingController();

  List<Map<String, dynamic>> moodEntries = [];

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😊', 'label': 'Happy', 'labelTh': 'มีความสุข', 'color': Color(0xFFFFD93D)},
    {'emoji': '😌', 'label': 'Calm', 'labelTh': 'สงบ', 'color': Color(0xFF6BCB77)},
    {'emoji': '😐', 'label': 'Neutral', 'labelTh': 'ปกติ', 'color': Color(0xFFA8DADC)},
    {'emoji': '😢', 'label': 'Sad', 'labelTh': 'เศร้า', 'color': Color(0xFF4D96FF)},
    {'emoji': '😰', 'label': 'Anxious', 'labelTh': 'วิตกกังวล', 'color': Color(0xFF9575CD)},
    {'emoji': '😡', 'label': 'Angry', 'labelTh': 'โกรธ', 'color': Color(0xFFFF6B6B)},
  ];

  // ---------------- LOAD HISTORY FROM DB ----------------
  Future<void> loadMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId == null) return;

    final data = await ApiService.getMoodByUser(userId);

    setState(() {
      moodEntries = data.map<Map<String, dynamic>>((item) {
        return {
          'mood': item['mood'],
          'note': item['note'] ?? '',
          'timestamp': DateTime.parse(item['timestamp']),
        };
      }).toList();
    });
  }

  // ---------------- SAVE TO DATABASE ----------------
  Future<void> saveMoodEntry() async {
    if (selectedMood == null) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณาเข้าสู่ระบบใหม่')),
      );
      return;
    }

    final success = await ApiService.createMood(
      userId: userId,
      mood: selectedMood!,
      note: noteController.text,
    );

    if (success) {
      await loadMoodHistory();

      setState(() {
        selectedMood = null;
        noteController.clear();
        currentStep = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกอารมณ์สำเร็จ'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('บันทึกไม่สำเร็จ'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('บันทึกอารมณ์ประจำวัน'),
        backgroundColor: Colors.purple,
      ),
      body: currentStep == 0 ? _buildForm() : _buildHistory(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: moods.length,
            itemBuilder: (context, index) {
              final mood = moods[index];
              final isSelected = selectedMood == mood['label'];

              return GestureDetector(
                onTap: () => setState(() => selectedMood = mood['label']),
                child: Container(
                  decoration: BoxDecoration(
                    color: mood['color'].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? mood['color'] : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood['emoji'], style: const TextStyle(fontSize: 36)),
                      const SizedBox(height: 4),
                      Text(mood['label']),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: noteController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'เขียนบันทึก...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedMood != null ? saveMoodEntry : null,
              child: const Text('บันทึก'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              await loadMoodHistory();
              setState(() => currentStep = 1);
            },
            child: const Text('ดูประวัติ'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      children: [
        Expanded(
          child: moodEntries.isEmpty
              ? const Center(child: Text('ยังไม่มีข้อมูล'))
              : ListView.builder(
                  itemCount: moodEntries.length,
                  itemBuilder: (context, index) {
                    final entry = moodEntries[index];
                    final mood = moods.firstWhere(
                      (m) => m['label'] == entry['mood'],
                    );

                    return ListTile(
                      leading: Text(mood['emoji'], style: const TextStyle(fontSize: 28)),
                      title: Text(mood['labelTh']),
                      subtitle: Text(entry['note']),
                      trailing: Text(
                        '${entry['timestamp'].day}/${entry['timestamp'].month}/${entry['timestamp'].year}',
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () => setState(() => currentStep = 0),
            child: const Text('กลับ'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
