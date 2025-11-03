# ---- Build Stage ----
# Use an Alpine-based node image for a small starting size
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency definition files
COPY package*.json ./

# Install dependencies (including dev dependencies for potential build steps)
RUN npm install --omit=dev

# ---- Final Stage ----
# Use a minimal production-ready base image
FROM node:20-slim

WORKDIR /app

# SRE: Run as a non-privileged user
# The 'node' image already comes with a non-root 'node' user (UID 1000)
# We will switch to this built-in user for the final stage.
USER node

# Copy only production dependencies from the builder stage
# Uses the /usr/local/lib/node_modules path standard for global packages
COPY --chown=node:node --from=builder /app/node_modules ./node_modules

# Copy application code
# Assuming the Express code is saved as 'server.js'
COPY --chown=node:node server.js .

# Set the environment variables for your application (from your Express code)
ENV BACKEND_API_URL='http://localhost:8080'
ENV PORT=80

# SRE: Container health check (required by assignment)
# The health check must target the correct port and endpoint defined in your Express code.
# The 'curl' package is not available in 'node:slim', so we use 'wget' or install 'curl'.
# Let's use wget as it's often available, or install curl for robustness (preferred).
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:${PORT}/healthz || exit 1

# Expose port and run application
EXPOSE ${PORT}
CMD ["node", "server.js"]
