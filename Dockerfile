# syntax=docker/dockerfile:1.7
# Multi-stage Dockerfile for QA-KB-task (Cypress E2E test-automation knowledge base).
# Stages: base -> deps -> build -> test -> runtime
# Cypress version is pinned from package.json (cypress ^13.17.0 -> 13.17.0),
# resolved from package-lock.json, not guessed.

ARG NODE_IMAGE=node:20.18.1-slim@sha256:b2c8e0eb8a6aeeae33b2711f8f516003e27ee45804e270468d937b3214f2f0cc
ARG CYPRESS_IMAGE=cypress/included:13.17.0@sha256:128490f34f1f2f7c0bab4dd1dbc4eaf0435ba99fe3e0f538d8ecb98b92e34d0f

FROM $NODE_IMAGE AS base
LABEL org.opencontainers.image.title="QA-KB-task"
LABEL org.opencontainers.image.description="Cypress E2E test-automation knowledge base (Phase 5 baseline)"
ENV NODE_ENV=development \
    CI=true \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_AUDIT=false
WORKDIR /app
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        fonts-liberation \
        libnss3 \
        libnspr4 \
        libatk1.0-0 \
        libatk-bridge2.0-0 \
        libcups2 \
        libdrm2 \
        libxkbcommon0 \
        libxcomposite1 \
        libxdamage1 \
        libxfixes3 \
        libxrandr2 \
        libgbm1 \
        libpango-1.0-0 \
        libcairo2 \
        libasound2 \
        libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

FROM base AS deps
COPY package.json package-lock.json ./
RUN npm ci --no-audit --no-fund --prefer-offline \
    && npm cache clean --force

FROM base AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN echo "build stage: no compile step for this repo (pure Cypress specs)" \
    && ls -1

FROM $CYPRESS_IMAGE AS test
WORKDIR /app
# The cypress/included image already bundles Cypress 13.17.0 + a browser, so we
# bring only the repo's own source (specs, fixtures, config, manifest) and rely
# on the image's Cypress. Do NOT copy node_modules from the build stage: it
# would shadow the image's bundled copy and can desync versions.
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/cypress ./cypress
COPY --from=build /app/cypress.config.js ./cypress.config.js
ENV CI=true \
    CYPRESS_INSTALL_BINARY=0 \
    VIDEO=false \
    SCREENSHOT=false
RUN echo "cypress/included image already contains Cypress 13.17.0; skipping browser download"
RUN cypress verify
# Run the existing suite headless. The repo's own `npm test` script is a
# placeholder (echo + exit 1), so we invoke Cypress directly here; this keeps
# package.json untouched (Phase 5 is Docker/Make/docs only).
RUN npx cypress run --headless --browser electron

FROM $NODE_IMAGE AS runtime
LABEL org.opencontainers.image.title="QA-KB-task"
LABEL org.opencontainers.image.description="Cypress E2E test-automation knowledge base (runtime)"
ENV NODE_ENV=production \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_AUDIT=false
WORKDIR /app
COPY --from=test /app/package.json ./package.json
COPY --from=test /app/cypress ./cypress
COPY --from=test /app/cypress.config.js ./cypress.config.js
RUN useradd --create-home --uid=1000 --shell=/bin/bash cypress \
    && chown -R cypress:cypress /app
USER cypress
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD node -e "console.log('runtime ok')" || exit 1
ENTRYPOINT ["node"]
CMD ["-e", "console.log('QA-KB-task runtime image — this repo has no server; use make test / make verify')"]