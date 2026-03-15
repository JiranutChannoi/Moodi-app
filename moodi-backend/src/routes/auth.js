const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const { Pool } = require("pg");

// ================= DATABASE =================
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl:
    process.env.NODE_ENV === "production"
      ? { rejectUnauthorized: false }
      : false,
});

// ================= EMAIL CONFIG =================
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false,
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS
  },
  tls: {
    rejectUnauthorized: false
  }
});

// ตรวจสอบ email server
transporter.verify(function (error, success) {
  if (error) {
    console.log("❌ Email server error:", error);
  } else {
    console.log("✅ Email server ready");
  }
});



// ================= REGISTER =================
router.post("/register", async (req, res) => {
  try {
    const { name, email, password } = req.body;

    if (!name || !email || !password) {
      return res.status(400).json({
        error: "กรุณากรอกข้อมูลให้ครบ",
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        error: "รหัสผ่านอย่างน้อย 6 ตัว",
      });
    }

    const dup = await pool.query(
      "SELECT 1 FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (dup.rows.length > 0) {
      return res.status(409).json({
        error: "อีเมลนี้ถูกใช้งานแล้ว",
      });
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
    console.error("REGISTER ERROR:", e);

    res.status(500).json({
      error: "Server error",
    });
  }
});



// ================= LOGIN =================
router.post("/login", async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        error: "กรุณากรอก email และ password",
      });
    }

    const q = await pool.query(
      "SELECT * FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (q.rows.length === 0) {
      return res.status(401).json({
        error: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
      });
    }

    const user = q.rows[0];

    const ok = await bcrypt.compare(
      password,
      user.password
    );

    if (!ok) {
      return res.status(401).json({
        error: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
      });
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
    console.error("LOGIN ERROR:", e);

    res.status(500).json({
      error: "Server error",
    });
  }
});



// ================= FORGOT PASSWORD =================
router.post("/forgot-password", async (req, res) => {
  try {
    const { email } = req.body;

    const user = await pool.query(
      "SELECT user_id FROM users WHERE email=$1",
      [email.toLowerCase()]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({
        error: "ไม่พบอีเมลนี้",
      });
    }

    const userId = user.rows[0].user_id;

    // create token
    const token = crypto
      .randomBytes(32)
      .toString("hex");

    const tokenHash = crypto
      .createHash("sha256")
      .update(token)
      .digest("hex");

    const expire = new Date(
      Date.now() + 1000 * 60 * 30
    ); // 30 นาที

    await pool.query(
      `INSERT INTO password_reset_tokens
      (user_id,token_hash,expires_at)
      VALUES ($1,$2,$3)`,
      [userId, tokenHash, expire]
    );

    const resetLink =
      `https://moodi-reset-password.vercel.app/?token=${token}`;

    console.log("📩 Sending email to:", email);

    const info = await transporter.sendMail({
      from: `"Moodi App" <${process.env.EMAIL_USER}>`,
      to: email,
      subject: "รีเซ็ตรหัสผ่าน Moodi",
      html: `
        <div style="font-family:sans-serif">

        <h2>รีเซ็ตรหัสผ่าน</h2>

        <p>คุณได้ขอรีเซ็ตรหัสผ่านสำหรับบัญชี Moodi</p>

        <a href="${resetLink}"
        style="
        padding:12px 20px;
        background:#7B68EE;
        color:white;
        text-decoration:none;
        border-radius:6px;
        display:inline-block;">
        รีเซ็ตรหัสผ่าน
        </a>

        <p>ลิงก์นี้จะหมดอายุภายใน 30 นาที</p>

        </div>
      `,
    });

    console.log("✅ Email sent:", info.messageId);

    res.json({
      message: "ส่งอีเมลรีเซ็ตรหัสผ่านแล้ว",
    });
  } catch (err) {
    console.error("FORGOT PASSWORD ERROR:", err);

    res.status(500).json({
      error: "server error",
    });
  }
});



// ================= RESET PASSWORD =================
router.post("/reset-password", async (req, res) => {
  try {
    const { token, password } = req.body;

    const tokenHash = crypto
      .createHash("sha256")
      .update(token)
      .digest("hex");

    const tokenResult = await pool.query(
      `SELECT *
       FROM password_reset_tokens
       WHERE token_hash=$1
       AND expires_at > NOW()
       AND used_at IS NULL`,
      [tokenHash]
    );

    if (tokenResult.rows.length === 0) {
      return res.status(400).json({
        error: "Token ไม่ถูกต้องหรือหมดอายุ",
      });
    }

    const resetToken = tokenResult.rows[0];

    const hash = await bcrypt.hash(
      password,
      10
    );

    await pool.query(
      "UPDATE users SET password=$1 WHERE user_id=$2",
      [hash, resetToken.user_id]
    );

    await pool.query(
      `UPDATE password_reset_tokens
       SET used_at=NOW()
       WHERE id=$1`,
      [resetToken.id]
    );

    res.json({
      message: "รีเซ็ตรหัสผ่านสำเร็จ",
    });
  } catch (err) {
    res.status(500).json({
      error: "server error",
    });
  }
});



// ================= CHANGE PASSWORD =================
router.post("/change-password", async (req, res) => {
  try {
    const {
      user_id,
      oldPassword,
      newPassword,
    } = req.body;

    const user = await pool.query(
      "SELECT * FROM users WHERE user_id=$1",
      [user_id]
    );

    if (user.rows.length === 0) {
      return res.status(404).json({
        error: "ไม่พบผู้ใช้",
      });
    }

    const match = await bcrypt.compare(
      oldPassword,
      user.rows[0].password
    );

    if (!match) {
      return res.status(401).json({
        error: "รหัสผ่านเดิมไม่ถูกต้อง",
      });
    }

    const hash = await bcrypt.hash(
      newPassword,
      10
    );

    await pool.query(
      "UPDATE users SET password=$1 WHERE user_id=$2",
      [hash, user_id]
    );

    res.json({
      message: "เปลี่ยนรหัสผ่านสำเร็จ",
    });
  } catch (err) {
    res.status(500).json({
      error: "server error",
    });
  }
});



module.exports = router;