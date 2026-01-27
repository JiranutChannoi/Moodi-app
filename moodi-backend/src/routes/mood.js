const express = require('express');
const router = express.Router();
const {
  createMood,
  getMoodByUser,
} = require('../controllers/mood.controller');

router.post('/', createMood);
router.get('/:user_id', getMoodByUser);

module.exports = router;
