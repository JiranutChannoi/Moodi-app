const prisma = require('../prisma');

exports.createMood = async (req, res, next) => {
  try {
    const { user_id, mood, note } = req.body;

    const result = await prisma.mood.create({
      data: { user_id, mood, note },
    });

    res.json(result);
  } catch (err) {
    next(err);
  }
};

exports.getMoodByUser = async (req, res, next) => {
  try {
    const user_id = Number(req.params.user_id);

    const data = await prisma.mood.findMany({
      where: { user_id },
      orderBy: { timestamp: 'desc' },
    });

    res.json(data);
  } catch (err) {
    next(err);
  }
};
