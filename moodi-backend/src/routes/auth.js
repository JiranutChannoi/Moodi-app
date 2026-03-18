const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const { Pool } = require("pg");
const { Resend } = require("resend");

// ================= DATABASE =================
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl:
    process.env.NODE_ENV === "production"
      ? { rejectUnauthorized: false }
      : false,
});

// ================= RESEND =================
const resend = new Resend(process.env.RESEND_API_KEY);

// ================= REGISTER =================
router.post("/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({ error: "กรุณากรอกข้อมูลให้ครบ" });
    }

    if (password.length < 6) {
      return res.status(400).json({ error: "รหัสผ่านอย่างน้อย 6 ตัว" });
    }

    const dup = await pool.query(
      "SELECT 1 FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (dup.rows.length > 0) {
      return res.status(409).json({ error: "อีเมลนี้ถูกใช้งานแล้ว" });
    }

    const hash = await bcrypt.hash(password, 10);

    const result = await pool.query(
      `INSERT INTO users (name,email,password)
       VALUES ($1,$2,$3)
       RETURNING user_id,name,email`,
      [name, email.toLowerCase(), hash]
    );

    res.status(201).json({
      message: "สมัครสมาชิกสำเร็จ",
      user: result.rows[0],
    });

  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Server error" });
  }
});

// ================= LOGIN =================
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    const q = await pool.query(
      "SELECT * FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (q.rows.length === 0) {
      return res.status(401).json({ error: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    const user = q.rows[0];

    const ok = await bcrypt.compare(password, user.password);

    if (!ok) {
      return res.status(401).json({ error: "อีเมลหรือรหัสผ่านไม่ถูกต้อง" });
    }

    res.json({
      message: "เข้าสู่ระบบสำเร็จ",
      user: {
        user_id: user.user_id,
        name: user.name,
        email: user.email,
      },
    });

  } catch (e) {
    res.status(500).json({ error: "Server error" });
  }
});


// ================= SEND OTP =================
router.post("/send-otp", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await pool.query(
      "SELECT user_id FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({ error: "ไม่พบอีเมลนี้" });
    }

    //generate OTP 6 หลัก
    const otp = Math.floor(100000 + Math.random() * 900000).toString();

    const expire = new Date(Date.now() + 5 * 60 * 1000); // 5 นาที

    //ลบ OTP เก่า (กัน spam)
    await pool.query(
      "DELETE FROM otp_codes WHERE email=$1",
      [email.toLowerCase()]
    );

    await pool.query(
      `INSERT INTO otp_codes (email, code, expires_at)
       VALUES ($1,$2,$3)`,
      [email.toLowerCase(), otp, expire]
    );

    // ส่ง email
    await resend.emails.send({
      from: "Moodi App <onboarding@resend.dev>",
      to: email,
      subject: "OTP รีเซ็ตรหัสผ่าน",
      html: `
        <h2>รหัส OTP ของคุณ</h2>
        <h1>${otp}</h1>
        <p>OTP นี้มีอายุ 5 นาที</p>
      `,
    });

    res.json({ message: "ส่ง OTP แล้ว" });

  } catch (err) {
    console.error("SEND OTP ERROR:", err);
    res.status(500).json({ error: "server error" });
  }
});


// ================= VERIFY OTP =================
router.post("/verify-otp", async (req, res) => {
  try {
    const { email, code } = req.body;

    const result = await pool.query(
      `SELECT * FROM otp_codes
       WHERE email=$1
       AND code=$2
       AND expires_at > NOW()
       AND used=false
       ORDER BY created_at DESC
       LIMIT 1`,
      [email.toLowerCase(), code]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({ error: "OTP ไม่ถูกต้องหรือหมดอายุ" });
    }

    await pool.query(
      "UPDATE otp_codes SET used=true WHERE id=$1",
      [result.rows[0].id]
    );

    res.json({ message: "OTP ถูกต้อง" });

  } catch (err) {
    res.status(500).json({ error: "server error" });
  }
});


// ================= RESET PASSWORD WITH OTP =================
router.post("/reset-password-otp", async (req, res) => {
  try {
    const { email, code, newPassword } = req.body;

    const result = await pool.query(
      `SELECT * FROM otp_codes
       WHERE email=$1
       AND code=$2
       AND used=true
       ORDER BY created_at DESC
       LIMIT 1`,
      [email.toLowerCase(), code]
    );

    if (result.rows.length === 0) {
      return res.status(400).json({ error: "OTP ไม่ถูกต้อง" });
    }

    const hash = await bcrypt.hash(newPassword, 10);

    await pool.query(
      "UPDATE users SET password=$1 WHERE email=$2",
      [hash, email.toLowerCase()]
    );

    res.json({ message: "เปลี่ยนรหัสผ่านสำเร็จ" });

  } catch (err) {
    res.status(500).json({ error: "server error" });
  }
});


// ================= CHANGE PASSWORD =================
router.post("/change-password", async (req, res) => {
  try {
    const { user_id, oldPassword, newPassword } = req.body;

    const user = await pool.query(
      "SELECT * FROM users WHERE user_id=$1",
      [user_id]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({ error: "ไม่พบผู้ใช้" });
    }

    const match = await bcrypt.compare(
      oldPassword,
      user.rows[0].password
    );

    if (!match) {
      return res.status(401).json({ error: "รหัสผ่านเดิมไม่ถูกต้อง" });
    }

    const hash = await bcrypt.hash(newPassword, 10);

    await pool.query(
      "UPDATE users SET password=$1 WHERE user_id=$2",
      [hash, user_id]
    );

    res.json({ message: "เปลี่ยนรหัสผ่านสำเร็จ" });

  } catch (err) {
    res.status(500).json({ error: "server error" });
  }
});

module.exports = router;