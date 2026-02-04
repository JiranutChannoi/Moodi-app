const prisma = require('../prisma');

exports.createChat = async (req, res, next) => {
  try {
    const { user_id, message, response } = req.body;

    const chat = await prisma.chatai.create({
      data: { user_id, message, response },
    });

    res.json(chat);
  } catch (err) {
    next(err);
  }
};

exports.getChatByUser = async (req, res, next) => {
  try {
    const user_id = Number(req.params.user_id);

    const data = await prisma.chatai.findMany({
      where: { user_id },
      orderBy: { timestamp: 'asc' },
    });

    res.json(data);
  } catch (err) {
    next(err);
  }
};
