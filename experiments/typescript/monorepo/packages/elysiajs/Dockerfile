# Adjust BUN_VERSION as desired
ARG BUN_VERSION=1.0
FROM oven/bun:${BUN_VERSION} AS base
RUN apt-get update -qq && \
  apt-get install -y build-essential pkg-config python-is-python3

# Install dependencies only when needed
FROM base AS deps
WORKDIR /app
COPY ./ ./
RUN bun install

# Development image, copy all the files and run the server
FROM base AS run
WORKDIR /app
# Don't run production as root
RUN addgroup --system --gid 1001 bunjs
RUN adduser --system --uid 1001 elysiajs
USER elysiajs
# Copy files
COPY --from=deps /app/ ./
# Set environment variables
ENV NODE_ENV=production
ENV PORT 3001
ENV HOSTNAME localhost
EXPOSE 3001
CMD ["bun", "packages/elysiajs/src/index.ts"]
