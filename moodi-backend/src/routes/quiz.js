const express = require('express');
const router = express.Router();

const {
  createQuiz,
  getQuizByUser,
} = require('../controllers/quiz.controller');

router.post('/', createQuiz);
router.get('/:user_id', getQuizByUser);

module.exports = router;
