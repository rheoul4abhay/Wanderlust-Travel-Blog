# Stage 1: Build Stage
FROM node:21 AS frontend-builder

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install

# Copy environment file and source code
COPY .env.docker .env
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM node:21-slim

WORKDIR /app

# Copy package files and install all dependencies (including Vite)
COPY package*.json ./
RUN npm install

# Copy built application files
COPY --from=frontend-builder /app/dist ./dist
COPY --from=frontend-builder /app/src ./src
COPY --from=frontend-builder /app/public ./public
COPY --from=frontend-builder /app/index.html ./
COPY --from=frontend-builder /app/vite.config.ts ./

# Copy environment file
COPY .env.docker .env.local

# Expose port 5173
EXPOSE 5173

# Start Vite preview server
CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "5173"]