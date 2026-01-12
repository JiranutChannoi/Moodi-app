FROM node:18-alpine

WORKDIR /app

COPY moodi-backend/package*.json ./
RUN npm install

COPY moodi-backend ./

EXPOSE 3000

CMD ["sh", "-c", "npx prisma generate && npx prisma migrate deploy && node src/server.js"]
