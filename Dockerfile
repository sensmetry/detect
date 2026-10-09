FROM --platform=linux/amd64 ghcr.io/astral-sh/uv:python3.13-bookworm-slim

ENV PYTHONUNBUFFERED=1 \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Resolve dependencies from the lock file before copying the source, so this layer is
# rebuilt only when the lock changes. --frozen fails rather than silently relocking.
COPY pyproject.toml uv.lock /app/
RUN uv sync --frozen --no-dev

COPY . /app/

# The Syside Pro licence is NOT baked into this image. Mount it at runtime and point
# SYSIDE_LICENSE_FILE at it; that is the variable that accepts a .lic certificate.
ENV SYSIDE_LICENSE_FILE=/secrets/syside-license.lic

ENV PORT=8080
EXPOSE 8080
CMD ["uv", "run", "--frozen", "--no-dev", "python", "webapp_main.py"]
