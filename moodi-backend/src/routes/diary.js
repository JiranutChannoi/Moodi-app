const express = require('express');
const router = express.Router();
const { 
  createDiary, 
  getDiaryByUser, 
  deleteDiary 
} = require('../controllers/diary.controller');

// ✅ สร้าง diary entry ใหม่
router.post('/', createDiary);

// ✅ ดึง diary entries ทั้งหมดของ user
router.get('/:userId', getDiaryByUser);


// ✅ ลบ diary entry (เพิ่มใหม่)
router.delete('/:id', deleteDiary);

module.exports = router;