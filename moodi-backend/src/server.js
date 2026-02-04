const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/auth');

const app = express();

// ------------------ Middleware ------------------
app.use(cors());
app.use(express.json());

// log request (debug)
app.use((req, _res, next) => {
  console.log(
    '➡',
    req.method,
    req.url,
    '| body:',
    req.body
  );
  next();
});

// ------------------ Health Check ------------------
app.get('/health', (_req, res) => {
  res.json({ ok: true, service: 'moodi-backend' });
});

// ------------------ Routes ------------------
app.use('/auth', authRoutes);

// ------------------ Error Handler (กันพังเงียบ) ------------------
app.use((err, _req, res, _next) => {
  console.error('💥 Server Error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// ------------------ Start Server ------------------
const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Moodi API running on port ${PORT}`);
});