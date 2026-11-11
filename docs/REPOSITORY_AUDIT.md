# Repository Audit — QA-KB-task

## File inventory

| Path | Type | Size | Purpose |
|---|---|---|---|
| `cypress.config.js` | Config | 317 B | Cypress config (baseUrl, chromeWebSecurity) |
| `package.json` | Manifest | 361 B | Project metadata, devDependencies |
| `package-lock.json` | Lockfile | 79 KB | Locked dependency tree |
| `README.md` | Docs | 6.4 KB | Honest documentation of repo reality |
| `cypress/e2e/KB_mainPage_OrderCard.cy.js` | Spec | 2.7 KB | Real E2E test (carousel + order) |
| `cypress/e2e/test.cy.js` | Spec | 447 B | Scratch fixture check (not a real test) |
| `cypress/fixtures/kb_order.json` | Fixture | 1.2 KB | Expected page content (synthetic) |
| `cypress/fixtures/example.json` | Fixture | 17 B | Cypress default, unused |
| `cypress/support/commands.js` | Support | 1.1 KB | Default scaffold, unmodified |
| `cypress/support/e2e.js` | Support | 1.1 KB | Default scaffold, unmodified |
| `KB_Manual_Test.xlsx` | Manual QA | 19 KB | Manual test cases |
| `KB_manualOrderCard.mp4` | Manual QA | 32.6 MB | Screen recording of manual flow |
| `Screenshot 2023-11-22 182322.png` | Manual QA | 79 KB | Supporting screenshot |
| `Screenshot 2023-11-22 182439.png` | Manual QA | 92 KB | Supporting screenshot |

Total tracked size: ~33 MB (99% binary artifacts).

## Dependency analysis

**`package.json`**:
```json
{
  "name": "qa-kb",
  "version": "1.0.0",
  "devDependencies": { "cypress": "^13.5.1" }
}
```

**`package-lock.json`**: Cypress resolved to `16.2.1` (Renovate PR #12 merged v16.2.1). Version drift: `package.json` says `^13.5.1`, lock has `16.2.1`.

**`npm audit`** (per README, not run live this session): 11 vulnerabilities — 2 critical, 7 high, 2 moderate. All transitive in Cypress deps (`lodash`, `minimatch`, `tmp`, `uuid`, etc.). Several open Dependabot/Renovate PRs propose fixes.

**`npm outdated`**: Not run (no Node on host). Defer to Phase 6.

## Config review

| File | Status | Issues |
|---|---|---|
| `cypress.config.js` | Minimal | `chromeWebSecurity: false` (required for off-site redirect); empty `setupNodeEvents` |
| `package.json` | Placeholder `test` script | `test: "echo \"Error: no test specified\" && exit 1"` — `npm test` useless |
| `.gitignore` | Missing | No ignore for `node_modules/`, `.env*`, IDE artifacts |

## Code quality findings

| Area | Finding | Severity |
|---|---|---|
| `KB_mainPage_OrderCard.cy.js` | Tightly coupled to live site DOM (`.slick-current`, `.cards-section__*`, `.fa-chevron-*`) | High — breaks on any marketing change |
| `test.cy.js` | Not a real test — only fixture `OTP` round-trip | Low — dead code |
| `cypress/support/*.js` | Default scaffolds, no custom commands | Low — missed reuse opportunity |
| `kb_order.json` | Synthetic data only, includes unused fields (`mobileNumber`, `FIN`, `OTP`) | Low — noise |
| Binary artifacts | 33 MB committed (MP4, XLSX, PNGs) — not needed for automated suite | High — repo bloat, clone time |

## Security scan

- **Git history secret scan**: `git log --all --full-history --oneline` — 9 commits, no secrets found. Fixtures contain only synthetic placeholders.
- **npm vulnerabilities**: 11 (per README) — all transitive, not this repo's code.
- **No `.env.example`** — no secret placeholders to check.
- **No auth, no rate limiting, no CORS** — test-only repo.

## CI/CD status

| Item | Status |
|---|---|
| GitHub Actions workflow | **None** — no `.github/workflows/` |
| `npm test` script | Placeholder — exits 1 |
| Test execution | Manual only: `npx cypress open/run` |
| Artifacts on failure | None configured |
| Dependabot/Renovate | 7 open PRs (cypress, lodash, minimatch, tmp, multi-deps) — all unmerged |

## Git hygiene

| Item | Status |
|---|---|
| Branches | `master` only locally; 7 open remote bot branches |
| `.gitignore` | **Missing** — no ignore for `node_modules/`, `.env*`, `.vscode/`, `.idea/` |
| Commit messages | Conventional-ish (`docs:`, `Update dependency`, `Merge pull request`) |
| `LICENSE` | **Missing** |
| `CHANGELOG.md` | **Missing** |
| Binary artifacts in history | MP4 (32.6 MB) committed — inflates repo size permanently |

## Summary

This is a **Cypress E2E test-automation exercise**, not an application. It has:
- No CI/CD (P1)
- No usable `npm test` script (P0)
- Tightly coupled live-site test (P1)
- 33 MB binary bloat (P2)
- 11 npm vulns (transitive)
- No `.gitignore`, no `LICENSE`
- 7 stale bot branches

Phase 3 scope: documentation/analysis only. All fixes deferred to Phases 4–11.