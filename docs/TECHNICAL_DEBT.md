# Technical Debt — QA-KB-task

All debt items classified P0–P3 with remediation roadmap mapping and burndown targets.

## Debt items

| ID | Priority | Title | Location | Description | Remediation | Target Phase | Burndown |
|---|---|---|---|---|---|---|---|
| TD-01 | P0 | `package.json` name mismatch | `package.json` | `name: "qa-kb"` ≠ repo `QA-KB-task` | Rename to `qa-kb-task` or `QA-KB-task` | 4 | Phase 4 |
| TD-02 | P0 | `npm test` placeholder | `package.json` | `test` script exits 1, doesn't run Cypress | Add `"test": "cypress run"` or `"test:e2e": "cypress run"` | 4 | Phase 4 |
| TD-03 | P1 | No CI/CD workflow | Repo root | No `.github/workflows/` — tests never run automatically | Add GitHub Actions: `npm ci` → `cypress run` | 10 | Phase 10 |
| TD-04 | P1 | Live-site test coupling | `KB_mainPage_OrderCard.cy.js` | Coupled to `kapitalbank.az` DOM/carousel content | Add `cy.intercept` mocks or accept flakiness | 11 | Phase 11 |
| TD-05 | P1 | `chromeWebSecurity: false` | `cypress.config.js` | Weakens browser security for off-site redirect | Keep (required) but document; consider `cy.origin` | 9 | Phase 9 |
| TD-06 | P1 | No `LICENSE` | Repo root | No license file | Add MIT `LICENSE` | 4 | Phase 4 |
| TD-07 | P2 | Binary artifacts in git | `KB_manualOrderCard.mp4`, `.xlsx`, `.png` | 33 MB bloat — not needed for CI | Move to wiki/LFS/artifacts; add to `.gitignore` | 4/7 | Phase 4 |
| TD-08 | P2 | No `.gitignore` | Repo root | Missing ignores for `node_modules/`, `.env*`, IDE | Create comprehensive `.gitignore` | 4 | Phase 4 |
| TD-09 | P2 | Unused fixture | `cypress/fixtures/example.json` | Cypress default, unused by specs | Delete | 7 | Phase 7 |
| TD-10 | P2 | Dead test file | `cypress/e2e/test.cy.js` | Only fixture round-trip, not a site test | Delete | 7 | Phase 7 |
| TD-11 | P2 | No custom commands | `cypress/support/commands.js` | Default scaffold, no reusable logic | Add custom commands for repeated patterns | 11 | Phase 11 |
| TD-12 | P3 | Version drift | `package.json` vs lock | `cypress ^13.5.1` vs lock `16.2.1` | Align `package.json` to `^16.2.1` | 6 | Phase 6 |
| TD-13 | P3 | No `CHANGELOG.md` | Repo root | No change log | Add `CHANGELOG.md` (keep-a-changelog) | 15 | Phase 15 |
| TD-14 | P3 | No `CONTRIBUTING.md` / `SECURITY.md` | Repo root | Missing standard docs | Add from templates | 15 | Phase 15 |
| TD-15 | P3 | Stale bot branches | GitHub remote | 7 open Dependabot/Renovate PRs, unmerged | Review/merge/close in Phase 6 | 6 | Phase 6 |
| TD-16 | P3 | No Docker/container | Repo root | No Dockerfile for consistent CI runs | Add multi-stage Cypress Dockerfile | 5 | Phase 5 |

## Remediation roadmap mapping

| Phase | Debt items addressed | Exit criteria |
|---|---|---|
| 4 Git hygiene | TD-01, TD-02, TD-06, TD-07, TD-08 | `.gitignore` added; `LICENSE` added; `package.json` name fixed; `test` script works; binary artifacts ignored/removed |
| 5 Container baseline | TD-16 | `Dockerfile`, `.dockerignore`, `Makefile` (`build`/`test`/`verify`); `docker build` passes |
| 6 Upgrade to latest | TD-12, TD-15 | Cypress/Node/latest; `npm audit fix`; bot PRs reviewed/merged |
| 7 Dead code & restructure | TD-09, TD-10 | `example.json` deleted; `test.cy.js` deleted; manual artifacts out of git |
| 9 Hardening | TD-05 | `chromeWebSecurity` documented; `cy.origin` evaluated |
| 10 CI/CD | TD-03 | GitHub Actions workflow green on push/PR; caches `node_modules` |
| 11 Tests | TD-04, TD-11 | Mocked `kapitalbank.az` via `cy.intercept`; custom commands for reuse |
| 15 Docs | TD-13, TD-14 | `CHANGELOG.md`, `CONTRIBUTING.md`, `SECURITY.md` added |

## Burndown targets

- **Phase 4 (Git hygiene)**: 5 items (TD-01,02,06,07,08) — target: 100% closure
- **Phase 5 (Container)**: 1 item (TD-16) — target: 100% closure
- **Phase 6 (Upgrade)**: 2 items (TD-12,15) — target: 100% closure
- **Phase 7 (Dead code)**: 2 items (TD-09,10) — target: 100% closure
- **Phase 9 (Hardening)**: 1 item (TD-05) — target: documented decision
- **Phase 10 (CI/CD)**: 1 item (TD-03) — target: green workflow
- **Phase 11 (Tests)**: 2 items (TD-04,11) — target: resilient mocked tests + custom commands
- **Phase 15 (Docs)**: 2 items (TD-13,14) — target: standard docs present

Total: 16 debt items. P0: 2, P1: 4, P2: 5, P3: 5.