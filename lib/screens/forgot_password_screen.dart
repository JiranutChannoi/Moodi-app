import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isEmailSent = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8F4FD), // สีฟ้าอ่อน
              Color(0xFFF8E8FF), // สีชมพูอ่อน
              Color(0xFFE8F4FD), // สีฟ้าอ่อน
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    // ปุ่มกลับ
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFF7B68EE),
                            size: 24,
                          ),
                        ),
                        Text(
                          'กลับ',
                          style: TextStyle(
                            color: Color(0xFF7B68EE),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),

                    // โลโก้
                    Hero(
                      tag: 'logo',
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/moodi_logo.png',
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF7B68EE),
                                      Color(0xFF9B59B6),
                                      Color(0xFFBA55D3),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    'M',
                                    style: TextStyle(
                                      fontSize: 60,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // แสดงเนื้อหาตามสถานะ
                    if (!_isEmailSent) ...[
                      _buildForgotPasswordForm(),
                    ] else ...[
                      _buildEmailSentSuccess(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ฟอร์มลืมรหัสผ่าน
  Widget _buildForgotPasswordForm() {
    return Column(
      children: [
        // หัวข้อ
        Text(
          'ลืมรหัสผ่าน?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B68EE),
          ),
        ),
        SizedBox(height: 12),

        // คำอธิบาย
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'ไม่ต้องกังวล! กรอกอีเมลของคุณและเราจะส่งลิงก์สำหรับรีเซ็ตรหัสผ่านให้คุณ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 50),

        // ไอคอนอีเมล
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Color(0xFF7B68EE).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xFF7B68EE).withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Icon(Icons.email_outlined, size: 40, color: Color(0xFF7B68EE)),
        ),
        SizedBox(height: 30),

        // ฟอร์มกรอกอีเมล
        Form(
          key: _formKey,
          child: Column(
            children: [
              // ช่องกรอกอีเมล
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: InputDecoration(
                    hintText: 'กรอกอีเมลของคุณ',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    prefixIcon: Container(
                      margin: EdgeInsets.all(12),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // ปุ่มส่งลิงก์รีเซ็ต
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF7B68EE),
                      Color(0xFF9B59B6),
                      Color(0xFFBA55D3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF9B7EDE).withOpacity(0.4),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSendResetLink,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ส่งลิงก์รีเซ็ต',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.send, color: Colors.white, size: 22),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 40),

        // ลิงก์กลับไปหน้าเข้าสู่ระบบ
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'จำรหัสผ่านได้แล้ว? ',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  color: Color(0xFF7B68EE),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // หน้าจอแสดงเมื่อส่งอีเมลสำเร็จ
  Widget _buildEmailSentSuccess() {
    return Column(
      children: [
        // ไอคอนสำเร็จ
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 60,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 30),

        // ข้อความสำเร็จ
        Text(
          'ส่งอีเมลเรียบร้อย!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7B68EE),
          ),
        ),
        SizedBox(height: 16),

        // คำอธิบาย
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'เราได้ส่งลิงก์สำหรับรีเซ็ตรหัสผ่านไปที่\n'),
                TextSpan(
                  text: _emailController.text,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B68EE),
                  ),
                ),
                TextSpan(
                  text:
                      '\n\nกรุณาตรวจสอบอีเมลของคุณและคลิกที่ลิงก์เพื่อรีเซ็ตรหัสผ่าน',
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 50),

        // ปุ่มเปิดแอปอีเมล
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.green.shade400],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.green.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _openEmailApp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'เปิดแอปอีเมล',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.open_in_new, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),

        // ปุ่มส่งอีเมลใหม่
        TextButton(
          onPressed: _resendEmail,
          child: Text(
            'ไม่ได้รับอีเมล? ส่งใหม่',
            style: TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 40),

        // ปุ่มกลับไปหน้าเข้าสู่ระบบ
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Color(0xFF7B68EE), width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(
            'กลับไปหน้าเข้าสู่ระบบ',
            style: TextStyle(
              color: Color(0xFF7B68EE),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ตรวจสอบรูปแบบอีเมล
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมล';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'รูปแบบอีเมลไม่ถูกต้อง';
    }
    return null;
  }

  // ส่งลิงก์รีเซ็ตรหัสผ่าน
  Future<void> _handleSendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // จำลองการส่งอีเมล (ใช้เวลา 2 วินาที)
      await Future.delayed(Duration(seconds: 2));

      // ในโค้ดจริง จะเรียก API เพื่อส่งอีเมลรีเซ็ตรหัสผ่าน
      // await AuthService.sendPasswordResetEmail(_emailController.text);

      setState(() {
        _isLoading = false;
        _isEmailSent = true;
      });

      // แสดงข้อความสำเร็จ
      _showSnackBar('ส่งลิงก์รีเซ็ตรหัสผ่านเรียบร้อยแล้ว', Colors.green);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showSnackBar('เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง', Colors.red);
    }
  }

  // ส่งอีเมลใหม่
  void _resendEmail() {
    setState(() {
      _isEmailSent = false;
    });
    _handleSendResetLink();
  }

  // เปิดแอปอีเมล
  void _openEmailApp() {
    _showSnackBar('เปิดแอปอีเมล...', Colors.blue);
    // ในโค้ดจริงจะใช้ package url_launcher
    // await launch('mailto:');
  }

  // แสดง SnackBar
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
