const express = require('express');
const router = express.Router();
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const prisma = new PrismaClient();

// ✅ Login API
router.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'กรุณากรอกข้อมูลให้ครบ' });
  }

  try {
    // หา user ตาม email
    const user = await prisma.user.findUnique({
      where: { email },
    });

    if (!user) {
      return res.status(401).json({ error: 'อีเมลนี้ไม่มีในระบบ' });
    }

    // ตรวจสอบ password
    const isPasswordValid = await bcrypt.compare(password, user.passwordHash);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'รหัสผ่านไม่ถูกต้อง' });
    }

    // สร้าง JWT token
    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    return res.json({
      message: 'เข้าสู่ระบบสำเร็จ',
      token,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error('Login Error:', error);
    return res.status(500).json({ error: 'เกิดข้อผิดพลาดจากเซิร์ฟเวอร์' });
  }
});

module.exports = router;
