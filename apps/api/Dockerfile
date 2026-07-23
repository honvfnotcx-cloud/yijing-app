FROM node:22-alpine
WORKDIR /app
COPY apps/api/package.json ./
RUN npm install
COPY apps/api/tsconfig.json apps/api/tsconfig.build.json ./
COPY apps/api/prisma ./prisma
RUN npx prisma generate
COPY apps/api/src ./src
RUN npm run build
EXPOSE 3000
CMD npx prisma migrate deploy && node dist/main.js
