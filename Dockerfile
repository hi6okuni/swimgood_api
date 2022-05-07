FROM node:alpine as builder
WORKDIR /app
COPY package.json .
COPY yarn.lock .
COPY prisma ./prisma/
RUN yarn install 
RUN yarn add argon2 --build-from-source
COPY . .
RUN yarn build


FROM node:alpine as run
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./
COPY --from=builder /app/dist ./dist
EXPOSE 3000
CMD ["yarn", "start:prod"]


