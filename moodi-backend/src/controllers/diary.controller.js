exports.createDiary = async (req, res, next) => {
  try {
    const { user_id, mood, event, solution, improve } = req.body;

    if (!user_id || !mood || !event) {
      return res.status(400).json({ message: 'Missing required fields' });
    }

    const entry = await prisma.diaryentries.create({
      data: {
        user_id: Number(user_id),
        mood,
        event,
        solution: solution || '',
        improve: improve || '',
      },
    });

    res.status(201).json(entry);
  } catch (err) {
    console.error(err); // ⭐ สำคัญ
    res.status(500).json({ message: 'Create diary failed' });
  }
};
