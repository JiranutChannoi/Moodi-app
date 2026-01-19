// ---------- Imports & Basic Setup ----------
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

// Log ทุก request (ช่วย debug)
app.use((req, _res, next) => {
  console.log(
    '➡',
    req.method,
    req.url,
    '| ct:',
    req.headers['content-type'] || '-',
    '| body:',
    req.body
  );
  next();
});

// ---------- DB ----------
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // ✅ สำคัญมาก: Railway Postgres ต้องใช้ SSL
  ssl: process.env.NODE_ENV === 'production'
    ? { rejectUnauthorized: false }
    : false,
});

// ทดสอบ DB ตอนบูต (ถ้าต่อไม่ได้ Railway จะรู้ทันที)
(async () => {
  try {
    const r = await pool.query('SELECT NOW() as now');
    console.log('✅ DB OK | time:', r.rows[0].now);
  } catch (e) {
    console.error('❌ DB FAIL:', e);
  }
})();

// ---------- Health Check ----------
app.get('/health', (_req, res) => {
  res.json({ ok: true });
});

// ---------- Register ----------
app.post('/users', async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ error: 'กรุณากรอก name, email, password ให้ครบ' });
    }

    if (password.length < 6) {
      return res.status(400).json({ error: 'รหัสผ่านอย่างน้อย 6 ตัว' });
    }

    const dup = await pool.query(
      'SELECT 1 FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (dup.rows.length > 0) {
      return res.status(409).json({ error: 'อีเมลนี้ถูกใช้งานแล้ว' });
    }

    const hashed = await bcrypt.hash(password, 10);

    const ins = await pool.query(
      'INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING user_id, name, email',
      [name, email.toLowerCase(), hashed]
    );

    return res.status(201).json({
      message: 'สมัครสมาชิกสำเร็จ',
      user: ins.rows[0],
    });
  } catch (e) {
    console.error('💥 Register error:', e);
    return res.status(500).json({
      error: 'Server error',
      detail: e.message,
    });
  }
});

// ---------- Login ----------
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ error: 'กรุณากรอก email และ password' });
    }

    const q = await pool.query(
      'SELECT * FROM users WHERE email = $1',
      [email.toLowerCase()]
    );

    if (q.rows.length === 0) {
      return res.status(401).json({ error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });
    }

    const user = q.rows[0];
    const ok = await bcrypt.compare(password, user.password);

    if (!ok) {
      return res.status(401).json({ error: 'อีเมลหรือรหัสผ่านไม่ถูกต้อง' });
    }

    return res.json({
      message: 'เข้าสู่ระบบสำเร็จ',
      user: {
        user_id: user.user_id,
        name: user.name,
        email: user.email,
      },
    });
  } catch (e) {
    console.error('💥 Login error:', e);
    return res.status(500).json({
      error: 'Server error',
      detail: e.message,
    });
  }
});

// ---------- Start Server ----------
const PORT = process.env.PORT || 3000;

// กัน process พังแบบเงียบ
process.on('unhandledRejection', (r) => {
  console.error('UNHANDLED REJECTION:', r);
});
process.on('uncaughtException', (e) => {
  console.error('UNCAUGHT EXCEPTION:', e);
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Moodi API running on port ${PORT}`);
});
