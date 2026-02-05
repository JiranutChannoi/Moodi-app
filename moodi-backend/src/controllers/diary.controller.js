const prisma = require('../prisma');
// ✅ สร้าง diary entry ใหม่
exports.createDiary = async (req, res, next) => {
  try {
    console.log('📝 Creating diary - BODY:', req.body);
    
    const { user_id, mood, event, solution, improve } = req.body;

    // Validation
    if (!user_id || !mood || !event || !solution || !improve) {
      console.log('❌ Validation failed:', { user_id, mood, event, solution, improve });
      return res.status(400).json({
        success: false,
        message: 'กรุณากรอกข้อมูลให้ครบถ้วน',
      });
    }

    // สร้าง diary entry
    const newEntry = await prisma.diaryentries.create({
      data: {
        user_id: Number(user_id),
        mood,
        event,
        solution,
        improve,
      },
    });

    console.log('✅ Diary created successfully:', newEntry.entry_id);

    res.status(201).json({
      success: true,
      message: 'บันทึกความคิดสำเร็จ',
      data: newEntry,
    });
  } catch (err) {
    console.error('❌ Create diary error:', err);
    next(err);
  }
};

// ✅ ดึง diary entries ทั้งหมดของ user
exports.getDiaryByUser = async (req, res, next) => {
  try {
    const userId = Number(req.params.user_id);
    console.log('📖 Getting diary for user:', userId);

    const entries = await prisma.diaryentries.findMany({
      where: {
        user_id: userId,
      },
      orderBy: {
        createdAt: 'desc', // ✅ แก้ตรงนี้
      },
    });

    console.log(`✅ Found ${entries.length} diary entries`);

    res.status(200).json({
      success: true,
      data: entries,
    });
  } catch (err) {
    console.error('❌ Get diary error:', err);
    next(err);
  }
};


// ✅ ลบ diary entry
exports.deleteDiary = async (req, res, next) => {
  try {
    const entryId = Number(req.params.id);
    console.log('🗑️ Deleting diary entry:', entryId);

    const entry = await prisma.diaryentries.findUnique({
      where: { entry_id: entryId },
    });

    if (!entry) {
      console.log('❌ Entry not found:', entryId);
      return res.status(404).json({
        success: false,
        message: 'ไม่พบบันทึกนี้',
      });
    }

    await prisma.diaryentries.delete({
      where: { entry_id: entryId },
    });

    console.log('✅ Diary deleted successfully');

    res.status(204).end();
  } catch (err) {
    console.error('❌ Delete diary error:', err);
    next(err);
  }
};