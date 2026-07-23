FROM node:22-alpine
WORKDIR /app
COPY package.json ./
RUN npm install
COPY tsconfig.json tsconfig.build.json ./
COPY prisma ./prisma
RUN npx prisma generate
COPY src ./src
RUN npm run build
EXPOSE 3000
CMD npx prisma migrate deploy && node dist/main.js