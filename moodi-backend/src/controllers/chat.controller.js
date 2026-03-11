const prisma = require('../prisma');

exports.createChat = async (req, res, next) => {
  try {
    const { user_id, message } = req.body;

    // ดึง keyword จาก database
    const keywords = await prisma.keywordreplies.findMany({
      where: { is_active: true }
    });

    let reply = "ฉันอยู่ตรงนี้เพื่อฟังคุณนะ 💜 อยากเล่าเพิ่มเติมไหม";
    let severity = "normal";
    let risk_flag = false;

    const lowerMessage = message.toLowerCase();

    for (const item of keywords) {

      if (lowerMessage.includes(item.keyword.toLowerCase())) {

        reply = item.response;
        severity = item.severity;

        if (severity === "crisis") {
          risk_flag = true;
        }

        break;
      }
    }

    const chat = await prisma.chatai.create({
      data: {
        user_id,
        message,
        response: reply,
        severity,
        risk_flag
      }
    });

    res.json({
      reply,
      severity,
      chat
    });

  } catch (err) {
    next(err);
  }
};

exports.getChatByUser = async (req, res, next) => {
  try {
    const user_id = Number(req.params.user_id);

    const data = await prisma.chatai.findMany({
      where: { user_id },
      orderBy: { created_at: 'asc' }
    });

    res.json(data);

  } catch (err) {
    next(err);
  }
};