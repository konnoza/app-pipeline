# ---- Build Stage ----
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install

# ---- Final Stage ----
FROM node:18-alpine
WORKDIR /app

# SRE: Run as non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=builder /app/node_modules ./node_modules
COPY index.js .

# SRE: Container health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget -q --spider http://localhost/healthz || exit 1

EXPOSE 80
CMD ["npm", "start"]