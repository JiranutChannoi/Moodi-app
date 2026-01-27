const express = require('express');
const router = express.Router();

const {
  createDiary,
  getDiaryByUser,
} = require('../controllers/diary.controller');

router.post('/', createDiary);
router.get('/:user_id', getDiaryByUser);

module.exports = router;
