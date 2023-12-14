FROM node:18-alpine

WORKDIR /app

COPY . .

RUN npm install -f

RUN npm run build

CMD ["npm", "run", "start"]
