# QA-KB-task - Phase 5 container baseline

This file records the **pre-existing red baseline** for the Cypress suite run
inside the Docker `test` stage. It is the behavior contract for Phases 6-11:
no application code is fixed here, and every later phase must reproduce this
result (or document a change).

## Verification commands

```
docker build --target test -t qa-kb-task-p5:test .   # exit 1
make verify                                          # exit 2
make lint                                            # exit 0
make down                                            # exit 0
```

Full captured output:
- `docs/docker-test-stage.log` - raw `docker build --target test .` output
- `docs/make-verify.log` - raw `make verify` output

## Environment

| Item | Value |
|---|---|
| Base image | `node:20.18.1-slim` (digest pinned) |
| Cypress image | `cypress/included:13.17.0` (digest pinned) |
| Cypress version (runtime) | 13.17.0 |
| Browser | Electron 118 (headless) |
| Node (image) | v22.13.0 |
| Cypress version (source) | 13.17.0, from `package-lock.json` line 540 |
| Target URL | `https://www.kapitalbank.az/en` (live production site) |

## Results

| Spec | Tests | Passing | Failing | Pending | Skipped |
|---|---|---|---|---|---|
| `KB_mainPage_OrderCard.cy.js` | 1 | 0 | 1 | 0 | 0 |
| `test.cy.js` | 1 | 1 | 0 | 0 | 0 |
| **Total** | **2** | **1** | **1** | **0** | **0** |

**Build exit code: 1** (one failing test fails the `test` stage, as designed).

## Failure detail (pre-existing, not fixed by Phase 5)

`KB_mainPage_OrderCard.cy.js` -> `KB_TS-01-TC-01` -> "Checking the orders
section on the home page":

```
AssertionError: Timed out retrying after 4000ms: Not enough elements found.
Found '3', expected '4'.
```

at `cypress/e2e/KB_mainPage_OrderCard.cy.js:25`. The fixture (`kb_order.json`)
expects 4 carousel slides; the live site currently renders 3. This is a
content/marketing-drift failure against a live third-party production site -
it is the known limitation documented in `README.md`, not a defect in this
repo's code.

## Specs that cannot run in Docker

None. Both specs were discovered and executed. Neither is BLOCKED or
NOT RUN. The repo has no local server, no database, no auth, and no mocks;
the suite runs entirely against the external site, which is reachable from
the container.

## Out of scope for this phase

- Fixing the failing spec (Phase 11 / test-engineer scope).
- The `npm test` script is still a placeholder (`echo "Error: no test
  specified" && exit 1`). Phase 5 deliberately invokes Cypress directly in
  the Dockerfile so the suite runs without touching `package.json`.
- Manual-QA artifacts (`KB_Manual_Test.xlsx`, `KB_manualOrderCard.mp4`,
  two screenshots) are excluded from the image via `.dockerignore` but stay
  in the repo.