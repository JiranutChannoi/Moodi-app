const prisma = require('../prisma');

exports.getRelaxSounds = async (_req, res, next) => {
  try {
    const sounds = await prisma.relaxsound.findMany({
      orderBy: { sound_id: 'asc' },
    });

    res.json(sounds);
  } catch (err) {
    next(err);
  }
};
