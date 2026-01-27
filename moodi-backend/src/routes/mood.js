import express from 'express';
import { createMood, getMoodByUser } from '../controllers/mood.controller.js';

const router = express.Router();

router.post('/', createMood);
router.get('/:user_id', getMoodByUser);

export default router;
