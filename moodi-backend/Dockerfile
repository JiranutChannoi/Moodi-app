# ใช้ Node ที่เบา
FROM node:20-alpine

# โฟลเดอร์ทำงานใน container
WORKDIR /app

# ติดตั้ง dependency
COPY package*.json ./
RUN npm ci --only=production

# คัดลอกโค้ดที่ต้องใช้
COPY prisma ./prisma
COPY src ./src

# generate prisma client (ใช้กับ schema ใน prisma/)
RUN npx prisma generate

# port ที่ service เปิด
EXPOSE 3000

# ตอน container start:
# 1) deploy migrations (apply migrations ใน prisma/migrations)
# 2) start server
CMD ["sh", "-c", "npx prisma migrate deploy && node src/server.js"]
