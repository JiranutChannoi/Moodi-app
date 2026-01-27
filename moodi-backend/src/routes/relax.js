const express = require('express');
const router = express.Router();

const {
  getRelaxSounds,
} = require('../controllers/relax.controller');

router.get('/', getRelaxSounds);

module.exports = router;
