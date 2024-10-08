# Rebuild the source code only when needed
FROM node:18-alpine  AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install -frozen-lockfile
COPY . .
RUN npm run build


FROM node:18-alpine AS runner
WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules/ ./node_modules/
# Automatically leverage output traces to reduce image size

EXPOSE 3000

ENV PORT 3000

CMD ["npx", "next", "start"]