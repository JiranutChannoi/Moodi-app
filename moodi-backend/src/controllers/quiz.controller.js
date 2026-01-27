const prisma = require('../prisma');

exports.createQuiz = async (req, res, next) => {
  try {
    const { user_id, total_score, level } = req.body;

    const result = await prisma.quizresults.create({
      data: { user_id, total_score, level },
    });

    res.json(result);
  } catch (err) {
    next(err);
  }
};

exports.getQuizByUser = async (req, res, next) => {
  try {
    const user_id = Number(req.params.user_id);

    const data = await prisma.quizresults.findMany({
      where: { user_id },
      orderBy: { timestamp: 'desc' },
    });

    res.json(data);
  } catch (err) {
    next(err);
  }
};
