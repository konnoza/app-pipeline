# ---- Build Stage ----
# Use an Alpine-based node image for a small starting size
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency definition files
COPY package*.json ./

# Install dependencies (including dev dependencies for potential build steps)
RUN npm install --omit=dev

# ---- Final Stage ----
# FIX: Switched to Alpine base for consistent, minimal size, and reliable package management
FROM node:20-alpine

WORKDIR /app

# SRE: Run as a non-privileged user
# The 'node' image already comes with a non-root 'node' user (UID 1000)
# We will switch to this built-in user for the final stage.
USER node

# Copy only production dependencies from the builder stage
# Uses the /usr/local/lib/node_modules path standard for global packages
COPY --chown=node:node --from=builder /app/node_modules ./node_modules

# Copy application code
# Assuming the Express code is saved as 'index.js'
COPY --chown=node:node index.js .

# Set the environment variables for your application (from your Express code)
ENV BACKEND_API_URL='http://localhost:8080'
ENV PORT=80

# SRE: Container health check (required by assignment)
# FIX: Changed 'apt-get' to 'apk add --no-cache curl' which works reliably on Alpine.
RUN apk add --no-cache curl

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:${PORT}/healthz || exit 1

# Expose port and run application
EXPOSE ${PORT}
CMD ["node", "server.js"]
