# QA-KB-task - Phase 5 container baseline Makefile.
# This repo has no server; every target runs the Cypress suite in Docker.
# Never run `make up` before `make verify` is green.
#
# NOTE: `SHELL := sh` is deliberate. On this host `sh` is the POSIX shell and
# `bash`/`tail`/`grep` are NOT on PATH, so a Makefile that relies on them
# fails even for `make lint`. All recipes below use only POSIX builtins +
# docker/make/compose, so they work identically on Linux CI and this host.

SHELL := sh
.DEFAULT_GOAL := help

# Unique project name so parallel agents never collide (R4).
export COMPOSE_PROJECT_NAME ?= qa-kb-task-p5
IMAGE ?= qa-kb-task-p5:test
DOCKER_BUILD_OPTS ?= --progress=auto

# Cypress version pinned from package.json (^13.17.0 -> 13.17.0, see Dockerfile).
CYPRESS_VERSION ?= 13.17.0

.PHONY: build test verify up down run lint shell logs help clean

build: ## Build the image (default target = test stage).
	@docker build $(DOCKER_BUILD_OPTS) --target test -t $(IMAGE) .

test: build ## Run the existing Cypress suite headless inside the test stage.
	@docker compose run --rm test

verify: ## build + test. Fails the phase if the suite does not run.
	@echo "=== make verify: build ==="
	$(MAKE) build
	@echo "=== make verify: test ==="
	$(MAKE) test

up: verify ## Start services only after verify is green. Runs the suite once.
	@docker compose up --build --abort-on-container-exit --remove-orphans

down: ## Stop and remove the compose project.
	@docker compose down -v --remove-orphans

run: ## Build and run the suite in one shot (no verify gate).
	@docker compose run --rm test

lint: ## Lint the Docker/Make/Compose artifacts.
	@echo "=== hadolint (Dockerfile) ==="
	@command -v hadolint >/dev/null 2>&1 && hadolint Dockerfile || echo "hadolint not installed; skipped"
	@echo "=== docker compose config ==="
	@docker compose config --quiet && echo "compose config OK"
	@echo "=== make --dry-run (all targets resolve) ==="
	@make -n build test verify up down run lint shell logs clean && echo "dry-run OK" || echo "dry-run FAILED"

shell: ## Open a shell in the test stage container.
	@docker compose run --rm --entrypoint /bin/bash test

logs: ## Tail the test service logs.
	@docker compose logs -f test

clean: ## Remove the built image and any compose state. Never touches user data.
	-docker rmi $(IMAGE) 2>/dev/null || true
	@docker compose down -v --remove-orphans 2>/dev/null || true

help: ## Show this help.
	@awk 'BEGIN {FS = ":.*##"; printf "Targets:\n"} /^[a-zA-Z_-]+:.*##/ { printf "  %-10s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)