import prisma from '../prisma.js';

export const createMood = async (req, res) => {
  const { user_id, mood, note } = req.body;

  const result = await prisma.mood.create({
    data: { user_id, mood, note }
  });

  res.json(result);
};

export const getMoodByUser = async (req, res) => {
  const user_id = Number(req.params.user_id);

  const data = await prisma.mood.findMany({
    where: { user_id }
  });

  res.json(data);
};
