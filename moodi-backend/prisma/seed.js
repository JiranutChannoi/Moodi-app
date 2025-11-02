// prisma/seed.js
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  // กันข้อมูลซ้ำ
  await prisma.asmrTrack.deleteMany();

  await prisma.asmrTrack.createMany({
    data: [
      { title: 'Forest Rain', category: 'nature', url: 'https://example.com/forest-rain.mp3', durationSeconds: 600 },
      { title: 'Ocean Waves', category: 'nature', url: 'https://example.com/ocean-waves.mp3', durationSeconds: 720 },
      { title: 'Fireplace',   category: 'cozy',   url: 'https://example.com/fireplace.mp3',  durationSeconds: 480 }
    ]
  });

  console.log('✅ Seeded ASMR tracks');
}

main()
  .then(() => prisma.$disconnect())
  .catch(async (e) => {
    console.error('Seed error:', e);
    await prisma.$disconnect();
    process.exit(1);
  });
