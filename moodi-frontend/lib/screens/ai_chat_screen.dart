import 'package:flutter/material.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  late AnimationController _animationController;

  // คำแนะนำด่วน
  final List<String> quickReplies = [
    'ฉันรู้สึกเหนื่อย',
    'วิธีการผ่อนคลาย',
    'เคล็ดลับ',
    'บอกเล่า',
    'ให้คำแนะนำ',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _animationController.forward();

    // ข้อความต้อนรับจาก AI
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          'text':
              'สวัสดีค่ะ! ฉันคือ MOODi AI ที่พร้อมฟังและให้คำแนะนำแบบมิตรภาพ 💜 มีอะไรอยากแบ่งปันไหมคะ?',
          'isUser': false,
          'time': _getCurrentTime(),
        });
      });
      _scrollToBottom();
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'time': _getCurrentTime(),
      });
    });

    _messageController.clear();
    _scrollToBottom();

    // จำลองการพิมพ์ของ AI
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        _messages.add({
          'text': _getAIResponse(message),
          'isUser': false,
          'time': _getCurrentTime(),
        });
      });
      _scrollToBottom();
    });
  }

  String _getAIResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('เหนื่อย') || lowerMessage.contains('เครียด')) {
      return 'เข้าใจความรู้สึกของคุณค่ะ 💙 การรู้สึกเหนื่อยเป็นเรื่องปกติ ลองหยุดพักสักครู่ หายใจลึกๆ และทำกิจกรรมที่ชอบดูนะคะ';
    } else if (lowerMessage.contains('ผ่อนคลาย')) {
      return 'วิธีการผ่อนคลายที่ดี:\n✨ ฟังเพลงเบาๆ\n✨ ทำสมาธิ 5-10 นาที\n✨ เดินเล่นกลางแจ้ง\n✨ ฟังเสียงธรรมชาติ\nลองดูนะคะ! 🌿';
    } else if (lowerMessage.contains('สวัสดี') ||
        lowerMessage.contains('หวัดดี') ||
        lowerMessage.contains('ดีจ้า')) {
      return 'สวัสดีค่ะ! 😊 วันนี้เป็นอย่างไรบ้างคะ? ยินดีที่ได้พูดคุยกับคุณ';
    } else if (lowerMessage.contains('ขอบคุณ') ||
        lowerMessage.contains('แซงคิว')) {
      return 'ยินดีค่ะ! 💜 หวังว่าจะช่วยให้คุณรู้สึกดีขึ้นนะคะ อย่าลืมดูแลตัวเองด้วยนะ';
    } else if (lowerMessage.contains('เศร้า') ||
        lowerMessage.contains('เหงา')) {
      return 'ฉันเข้าใจความรู้สึกของคุณค่ะ 🤗 ทุกความรู้สึกเป็นเรื่องปกติ ลองพูดคุยกับคนใกล้ชิดหรือทำกิจกรรมที่ชอบดูนะคะ';
    } else if (lowerMessage.contains('เคล็ดลับ') ||
        lowerMessage.contains('แนะนำ')) {
      return 'เคล็ดลับดูแลสุขภาพจิต:\n🌟 นอนหับพักผ่อนเพียงพอ\n🌟 ออกกำลังกายสม่ำเสมอ\n🌟 กินอาหารมีประโยชน์\n🌟 หาเวลาทำสิ่งที่รัก\n🌟 พูดคุยกับคนที่เข้าใจ';
    } else {
      return 'ขอบคุณที่แบ่งปันความรู้สึกนะคะ 💜 ฉันเข้าใจและพร้อมรับฟังเสมอ หากต้องการคำแนะนำเพิ่มเติม บอกฉันได้เลยนะคะ 😊';
    }
  }

  void _scrollToBottom() {
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
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
            colors: [
              Color(0xFFE1BEE7),
              Color(0xFFCE93D8),
              Color(0xFFBBDEFB),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildChatList()),
              if (_messages.length <= 1) _buildQuickReplies(),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFF6A1B9A)),
                  onPressed: () => Navigator.pop(context),
                ),
                Spacer(),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                  ),
                  child: Icon(Icons.person, color: Colors.white, size: 24),
                ),
              ],
            ),
            SizedBox(height: 12),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800),
              curve: Curves.elasticOut,
              builder: (context, double value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1BEE7), Color(0xFFBBDEFB)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9C27B0).withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text('🤖', style: TextStyle(fontSize: 50)),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'พูดคุยกับผู้ช่วย AI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),
            SizedBox(height: 4),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF9C27B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'MOODi AI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A1B9A),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'พร้อมรับฟังและให้คำแนะนำเพื่อจิตใจของคุณ',
              style: TextStyle(fontSize: 12, color: Color(0xFF7B1FA2)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(
          message['text'],
          message['isUser'],
          message['time'],
          index,
        );
      },
    );
  }

  Widget _buildMessageBubble(String text, bool isUser, String time, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.smart_toy, color: Colors.white, size: 18),
                ),
              ),
              SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: isUser
                          ? LinearGradient(
                              colors: [Color(0xFF7B68EE), Color(0xFF9C27B0)],
                            )
                          : LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: isUser ? Radius.circular(20) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 14,
                        color: isUser ? Colors.white : Color(0xFF4A148C),
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (isUser) ...[
              SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.person, color: Colors.white, size: 18),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'คำแนะนำด่วน',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6A1B9A),
            ),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: quickReplies.map((reply) {
              return TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(
                  milliseconds: 400 + (quickReplies.indexOf(reply) * 100),
                ),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: GestureDetector(
                  onTap: () => _sendMessage(reply),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFE1BEE7).withOpacity(0.8),
                          Color(0xFFCE93D8).withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Color(0xFF9C27B0).withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF9C27B0).withOpacity(0.2),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      reply,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6A1B9A),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFF9C27B0).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'พิมพ์ข้อความ...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: _sendMessage,
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _sendMessage(_messageController.text),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF7B68EE), Color(0xFF9C27B0)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF9C27B0).withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
