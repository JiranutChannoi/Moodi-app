const prisma = require('../prisma');

exports.createDiary = async (req, res, next) => {
  try {
    const { user_id, mood, event, solution, improve } = req.body;

    const entry = await prisma.diaryentries.create({
      data: { user_id, mood, event, solution, improve },
    });

    res.json(entry);
  } catch (err) {
    next(err);
  }
};

exports.getDiaryByUser = async (req, res, next) => {
  try {
    const user_id = Number(req.params.user_id);

    const data = await prisma.diaryentries.findMany({
      where: { user_id },
      orderBy: { entry_id: 'desc' },
    });

    res.json(data);
  } catch (err) {
    next(err);
  }
};
