# ---- Build Stage ----
# Use a full Python image to build dependencies
FROM python:3.11-slim AS builder

WORKDIR /app

# Install dependencies
COPY requirements.txt .
# SRE Note: Running as default (root) installs dependencies to /root/.local
RUN pip install --no-cache-dir --user -r requirements.txt

# ---- Final Stage ----
# Use a minimal, non-root image for security
FROM python:3.11-slim

WORKDIR /app

# SRE: Run as a non-privileged user
RUN useradd --create-home appuser
USER appuser

# Copy installed packages from the builder stage
# FIX: The source path MUST be /root/.local (where pip installed the packages)
# The destination path is the home directory of the newly created 'appuser'
COPY --chown=appuser:appuser --from=builder /root/.local /home/appuser/.local
# Copy application code
COPY --chown=appuser:appuser main.py .

# Set path to include user's local bin
ENV PATH="/home/appuser/.local/bin:${PATH}"

# SRE: Container health check (required by assignment)
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1

# Expose port and run application
EXPOSE 8080
CMD ["python", "main.py"]
