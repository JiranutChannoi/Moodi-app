FROM node:18-alpine

WORKDIR /app

# copy package.json และ package-lock.json
COPY package*.json ./
RUN npm install

# copy source code ทั้งหมด
COPY . .

EXPOSE 3000

CMD ["sh", "-c", "npx prisma generate && npx prisma migrate deploy && node src/server.js"]
