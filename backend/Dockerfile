# Stage 1
FROM node:21 AS backend-builder

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy source code
COPY . .

# Stage 2
FROM node:21-slim

WORKDIR /app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm ci --omit=dev

# Copy application files (excluding node_modules)
COPY --from=backend-builder /app/server.js ./
COPY --from=backend-builder /app/config ./config
COPY --from=backend-builder /app/controllers ./controllers
COPY --from=backend-builder /app/models ./models
COPY --from=backend-builder /app/routes ./routes
COPY --from=backend-builder /app/services ./services
COPY --from=backend-builder /app/utils ./utils
COPY --from=backend-builder /app/api ./api
COPY --from=backend-builder /app/data ./data

COPY .env.docker .env

EXPOSE 8080

CMD ["npm", "start"]