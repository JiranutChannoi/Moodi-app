const express = require('express');
const router = express.Router();
const {
  createChat,
  getChatByUser,
} = require('../controllers/chat.controller');

router.post('/', createChat);
router.get('/:user_id', getChatByUser);

module.exports = router;
