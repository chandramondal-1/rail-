FROM node:22-alpine

WORKDIR /app

# Install production dependencies first so Docker can cache this layer.
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

COPY src ./src

ENV NODE_ENV=production
ENV PORT=8787
EXPOSE 8787

# The key is provided at runtime through environment variables only.
CMD ["node", "src/server.js"]
