const express = require('express');
const cors = require('cors');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const moodRoutes = require('./routes/mood');
const diaryRoutes = require('./routes/diary');
const quizRoutes = require('./routes/quiz');
const chatRoutes = require('./routes/chat');
const relaxRoutes = require('./routes/relax');

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
app.use('/mood', moodRoutes);
app.use('/diary', diaryRoutes);
app.use('/quiz', quizRoutes);
app.use('/chat', chatRoutes);
app.use('/relax', relaxRoutes);

// ------------------ 404 Handler ------------------
app.use((req, res) => {
  res.status(404).json({
    error: 'Route not found',
    path: req.originalUrl,
  });
});

// ------------------ Error Handler ------------------
app.use((err, _req, res, _next) => {
  console.error('💥 Server Error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// ------------------ Start Server ------------------
const PORT = process.env.PORT || 3000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Moodi API running on port ${PORT}`);
});
