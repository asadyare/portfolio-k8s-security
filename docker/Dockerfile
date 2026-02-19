FROM node:20-alpine

# Create non-root user early
RUN addgroup -S app && adduser -S app -G app

WORKDIR /app

# Copy only what is needed for install
COPY package.json package-lock.json ./

# Install production dependencies only
RUN npm ci --omit=dev && npm cache clean --force

# Copy built artifacts only
COPY dist ./dist

# Drop privileges
USER app

# App listens on non-privileged port
EXPOSE 3000

CMD ["node", "dist/index.js"]