# Stage 1: Build Stage
FROM node:21 AS frontend-builder

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm install

# Copy source code and build
COPY . .
RUN npm run build

# Stage 2: Production Stage
FROM node:21-slim

WORKDIR /app

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm install --omit=dev

# Copy built application files
COPY --from=frontend-builder /app/dist ./dist
COPY --from=frontend-builder /app/src ./src
COPY --from=frontend-builder /app/public ./public
COPY --from=frontend-builder /app/index.html ./
COPY --from=frontend-builder /app/vite.config.ts ./

# Copy the .env.sample file to .env.local
COPY .env.docker .env.local

# Expose port 5173 for the Node.js application
EXPOSE 5173

# Define the default command to run the application in development mode
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]