const prisma = require('../prisma');

exports.createDiary = async (req, res, next) => {
  try {
    const { user_id, mood, event, solution, improve } = req.body;

    // 🔎 DEBUG สำคัญมาก
    console.log('📥 DIARY BODY:', req.body);

    if (!user_id || !mood || !event || !solution || !improve) {
      return res.status(400).json({
        error: 'ข้อมูลไม่ครบ',
      });
    }

    const entry = await prisma.diaryentries.create({
      data: {
        user_id: Number(user_id),
        mood,
        event,
        solution,
        improve,
      },
    });

    res.status(201).json(entry);
  } catch (err) {
    console.error('❌ CREATE DIARY ERROR:', err);
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

exports.deleteDiary = async (req, res, next) => {
  try {
    const entry_id = Number(req.params.id);

    await prisma.diaryentries.delete({
      where: { entry_id },
    });

    res.json({ message: 'Deleted successfully' });
  } catch (err) {
    next(err);
  }
};

