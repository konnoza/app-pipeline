# ---- Build Stage ----
# Use an Alpine-based node image for a small starting size
FROM node:22-alpine AS builder

WORKDIR /app

# Copy dependency definition files
# FIX: Adjusted to only copy package.json as the lock file is reported missing.
COPY package.json ./

# Install dependencies. Running npm install without a lock file will pull the latest 
# versions allowed by package.json, which helps resolve CVEs.
RUN npm install --omit=dev 

# ---- Final Stage ----
# FIX: Switched back to Alpine base for consistent, minimal size, and reliable package management
FROM node:22-alpine

WORKDIR /app

# Copy only production dependencies from the builder stage
COPY --chown=node:node --from=builder /app/node_modules ./node_modules

# Copy application code
COPY --chown=node:node index.js .

# Set the environment variables
ENV BACKEND_API_URL='http://localhost:8080'
ENV PORT=80

# CRITICAL FIX: Install 'curl' for the HEALTHCHECK. This must run as root.
RUN apk add --no-cache curl

# Now switch to the non-root user for security
# All commands from here (including CMD) will run as the 'node' user.
USER node

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:${PORT}/healthz || exit 1

# Expose port and run application
EXPOSE ${PORT}
CMD ["node", "index.js"]
