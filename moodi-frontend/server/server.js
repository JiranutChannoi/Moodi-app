const express = require('express');
const { Pool } = require('pg');
const bcrypt = require('bcrypt');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// ✅ เชื่อมต่อ PostgreSQL
const pool = new Pool({
  user: 'postgres',        // เปลี่ยนเป็น username ของคุณ
  host: 'localhost',
  database: 'moodi_db',    // เปลี่ยนเป็นชื่อ database ของคุณ
  password: '123456', // เปลี่ยนเป็น password ของคุณ
  port: 5432,
});

// ทดสอบการเชื่อมต่อ
pool.connect((err, client, release) => {
  if (err) {
    console.error('❌ Error connecting to PostgreSQL:', err.stack);
  } else {
    console.log('✅ Connected to PostgreSQL');
    release();
  }
});

// ✅ API สมัครสมาชิก (POST /users)
app.post('/users', async (req, res) => {
  const { name, email, password } = req.body;

  // ตรวจสอบข้อมูล
  if (!name || !email || !password) {
    return res.status(400).json({ error: 'กรุณากรอกข้อมูลให้ครบถ้วน' });
  }

  try {
    // ตรวจสอบว่าอีเมลซ้ำหรือไม่
    const checkEmail = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (checkEmail.rows.length > 0) {
      return res.status(409).json({ error: 'อีเมลนี้ถูกใช้งานแล้ว' });
    }

    // เข้ารหัสรหัสผ่าน
    const hashedPassword = await bcrypt.hash(password, 10);

    // บันทึกลงฐานข้อมูล
    const result = await pool.query(
      'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING user_id, name, email',
      [name, email.toLowerCase(), hashedPassword]
    );

    console.log('✅ User created:', result.rows[0]);

    res.status(201).json({
      message: 'สมัครสมาชิกสำเร็จ',
      user: result.rows[0],
    });
  } catch (error) {
    console.error('❌ Error creating user:', error);
    res.status(500).json({ error: 'เกิดข้อผิดพลาดในการสมัครสมาชิก' });
  }
});

// ✅ API ดึงข้อมูลผู้ใช้ทั้งหมด (GET /users)
app.get('/users', async (req, res) => {
  try {
    const result = await pool.query('SELECT user_id, name, email FROM users');
    res.json(result.rows);
  } catch (error) {
    console.error('❌ Error fetching users:', error);
    res.status(500).json({ error: 'ไม่สามารถดึงข้อมูลได้' });
  }
});


// ✅ API Login (POST /login)
app.post('/login', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: 'กรุณากรอกอีเมลและรหัสผ่าน' });
  }

  try {
    const result = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });
    }

    const user = result.rows[0];
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });
    }

    res.json({
      message: 'เข้าสู่ระบบสำเร็จ',
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (error) {
    console.error('❌ Error logging in:', error);
    res.status(500).json({ error: 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ' });
  }
});

// เริ่มเซิร์ฟเวอร์
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});