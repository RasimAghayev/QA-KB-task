# Improvement Roadmap — QA-KB-task

- **Date (UTC):** 2026-11-10
- **Phase:** 3 (Audit & plan) — **Gate 10: awaiting approval**
- **Scope:** Cypress E2E test repo (JS/Node). No application runtime to deploy as a service; roadmap is adapted to test automation.

## Goals
1. Make test execution reproducible (container + pinned toolchain) and runnable via a standard verify command.
2. Establish basic CI quality gates with reasonable runtime.
3. Resolve known dependency vulnerabilities and keep Cypress/deps current.
4. Improve test reliability/readability and clean low-value artifacts/config where safe.
5. Document reality, constraints, and decisions.

## Phase-by-phase plan (Phases 4–11 applicability)

| Phase | Applicability | Planned work for this repo | Risks / notes | Exit signal |
|---|---|---|---|---|
| 4 — Git hygiene | **Applicable** | History/secret scan (gitleaks) over full history (redacted reporting); review open bot branches (do not blindly merge; dependency bumps belong to Phase 6 context); ensure `.gitignore` covers Cypress outputs/artifacts as needed; consider pre-commit secret scan hook. Handle large binaries only with explicit decision (LFS/retention) — not done implicitly. | Bot branches may conflict with Phase 6; binary rewrite/removal impacts history (Gate 1 if rewrite). | Hygiene findings documented; only intended branches remain per rules. |
| 5 — Container baseline | **Applicable (adapted)** | Add `Dockerfile` (multi-stage as suitable: deps/install → test runner) to run Cypress headless in Docker; `.dockerignore`; minimal `Makefile` (`build`, `test`, `verify` = build+test; others as useful). Capture `docs/BASELINE.md` (current test results/behavior) — noting tests hit live external site, so baseline may be environment/network-sensitive. | Live-site dependency can make container runs flaky/non-deterministic; may need documented constraints rather than perfect hermeticity. | `make verify` runnable in Docker with results recorded (or red baseline documented with evidence). |
| 6 — Upgrade to latest | **Applicable** | Keep `cypress` at latest stable (currently up to date); address transitive vulns from `npm audit` via safe updates/overrides per registry evidence; refresh lockfile; align CI actions if added. Record any blocking advisories. | Overrides/resolutions can change behavior; Cypress major/runtime changes require validation. | Deps/vulns resolved or documented blockers; tests/baseline compared in Docker. |
| 7 — Dead code & restructure | **Applicable (light)** | Remove/repurpose unused artifacts in codebase scope: unused `example.json`, low-value `test.cy.js` (or convert to meaningful check) if justified; clean redundant config/comments; align package naming/metadata where safe. **Do not delete manual evidence files (xlsx/mp4/png) without explicit decision** (may be required deliverables). | Deleting evidence artifacts is potentially destructive to task intent — requires decision. | No unjustified dead test/config left; behavior preserved against baseline. |
| 8 — Architecture | **Limited / mostly n/a** | No app architecture to refactor (KISS/YAGNI: avoid inventing layers). Possible small improvements: test structure/helpers/page-object only if they clearly reduce duplication/brittleness for this tiny suite; document selector strategy. DDD/EDA/Clean/hexagonal/SOLID — **n/a** (no domain/service boundaries). DRY — apply only if duplication is real. | Over-engineering a 1–2 spec exercise. | Any change justified; otherwise explicit n/a rationale recorded. |
| 9 — Hardening | **Applicable (scoped)** | Review `chromeWebSecurity:false` necessity; ensure no secrets committed; add/configure secret scanning in CI if introduced; document external dependency and data-handling notes. AuthZ/DB/API-hardening items largely **n/a** (no owned service). | Limited ability to "harden" a third-party live target; focus on repo/toolchain hygiene. | Security checklist for in-scope items documented. |
| 10 — CI/CD | **Applicable** | Add GitHub Actions workflow (if repo hosted on GitHub) to run lint/checks if any + `make verify` (Docker/test stage) on PR/push; cache deps; timeouts; least-privilege permissions; pin actions by SHA. Account for live-site flakiness in design (retries policy explicit/documented, not hidden). **PR pipeline target ≤ 10 min** where feasible. | External site can cause nondeterministic CI; may need clear expectations. | Real CI run green (or documented constraint) with timings recorded. |
| 11 — Tests | **Applicable** | Strengthen meaningful assertions, fix assertion-form issues, improve selector robustness where possible, clarify/trim scratch test, and document coverage/limitations. Run in Docker and report real results in `docs/TEST_REPORT.md` and strategy in `docs/TESTING_STRATEGY.md`. | Cannot fully eliminate dependence on live external UI/content. | Suite green in Docker/CI (or baseline-documented failures explained); honest reporting. |

## Phases 12–16 (later, ecosystem-level) — quick view
| Phase | Expected status for QA-KB-task | Rationale |
|---|---|---|
| 12 Merge small repos | Likely **n/a** unless grouped | Standalone QA exercise; no confirmed merge target now |
| 13 Shared library | **n/a** | No reusable shared logic surfaced (single small suite) |
| 14 Rename | Possible **n/a** / optional | Naming mismatch noted; only if explicitly desired/approved |
| 15 Docs/manifest/diagrams | **Applicable** | Refresh README, add standard docs/manifest if required by program; diagrams only if meaningful |
| 16 Platform repo | **n/a** | Not a deployable service in a platform stack |

## Decisions / where standing decisions land
- **Dependency upgrades (D1/D3):** Cypress/transitives handled in Phase 6 using registry-verified latest stable; no new dependency added without a recorded decision and evidence.
- **Docker standard (D5):** Phase 5 introduces containerized test execution (`make verify` builds/tests in Docker) adapted to a test-only repo.
- **Behavior preservation:** Phase 5 baseline records current observable behavior; later phases compare against it (acknowledging external-site variability).
- **Principles:** KISS/YAGNI prioritized — no speculative app architecture; DRY only for real duplication.

## Risks & assumptions
- **Assumption:** Primary value is preserving the interview task's intent (Kapital Bank order-card flow check) while improving reliability/tooling.
- **Risk:** Live third-party site changes/availability can break tests independent of repo changes — must be documented, not hidden.
- **Risk:** Binary manual artifacts may be required deliverables; retention/removal needs explicit choice.
- **Assumption:** No secrets are stored in repo; placeholder fixture values are synthetic.

## Out of scope for this plan (unless separately approved)
- Changing the target site or creating mocks of Kapital Bank (would alter task nature) — only consider if explicitly requested/approved.
- History rewrites, force-pushes, branch deletions beyond approved gates, or dependency additions without decision records.
- Production deployment (no service exists).

## Approval
**Gate 10:** This roadmap/plan requires approval before any Phase 4+ implementation work begins for `QA-KB-task`.
