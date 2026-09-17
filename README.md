# QA-KB-task

A Cypress QA test-automation exercise against **Kapital Bank**'s public
website (`kapitalbank.az`) — package.json's own description calls it a
"KB interview task with cypress write". It has no application of its
own; the tests drive a live third-party production site.

This README documents `master` as it actually is; no source files were
changed to produce it.

## Architecture style

Not applicable — this repo has no application layer or runtime service
to label with a design pattern. It is a **Cypress E2E test-automation
task**, organized per Cypress's own standard convention (`cypress/e2e`,
`cypress/support`, `cypress/fixtures`), plus a few manual-QA artifacts
alongside it. (Per the portfolio's `[R112]` rule: this is the honest
label for what this repo is.)

## What's actually here

| Path | Purpose |
|---|---|
| `cypress.config.js` | `baseUrl` = `https://www.kapitalbank.az/en`, `chromeWebSecurity: false` (needed because the test follows an off-site redirect — see below). |
| `cypress/e2e/KB_mainPage_OrderCard.cy.js` | The real, developed test: `KB_TS-01-TC-01`, verifying the card-order carousel on the Kapital Bank home page — cycles the carousel left/right, checks the slide count, then checks the visible card's title, description, feature list, image, and "Order" button all match the expected text/values loaded from the fixture, and finally follows the Order button's `href` off-site (to `ccl.kapitalbank.az`) and checks the resulting page title. |
| `cypress/e2e/test.cy.js` | A small scratch/sanity test, unrelated to the site itself — just confirms the `kb_order` fixture loads and its `OTP` field reads back as `'1234'`. Reads as a fixture-loading check written while building the real test, not a page test in its own right. |
| `cypress/fixtures/kb_order.json` | Expected page content for `KB_mainPage_OrderCard.cy.js` (titles, descriptions, card counts, image name, link fragments) plus a few standalone fields (`mobileNumber`, `FIN`, `OTP`) that aren't used by either spec beyond `test.cy.js`'s `OTP` check. All are obviously synthetic placeholders, not real user data (`OTP: "1234"`, `mobileNumber: "511111111"`, `FIN: "123XH45"`). |
| `cypress/fixtures/example.json` | Cypress's default example fixture, unused by either spec. |
| `cypress/support/commands.js`, `cypress/support/e2e.js` | Cypress's default scaffold files, unmodified — no custom commands added. |
| `KB_Manual_Test.xlsx` | A manual test-case spreadsheet (~19 KB), presumably the manual QA counterpart to the automated Cypress test. |
| `KB_manualOrderCard.mp4` | A ~32.6 MB screen recording of the manual order-card flow being walked through by hand. |
| `Screenshot 2023-11-22 182322.png`, `Screenshot 2023-11-22 182439.png` | Two supporting screenshots from the same manual-testing session. |
| `package.json` | `name: "qa-kb"` (note: doesn't match the repo name `QA-KB-task`). One dev dependency: `cypress ^13.5.1`. The `test` script is Cypress's own unedited placeholder — `echo "Error: no test specified" && exit 1` — so **`npm test` does not run the Cypress suite**; there's no `test`/`build`/`start` script that does. |

No `.github/` workflow exists — unlike some of the other repos in this
portfolio, this one has no CI wired up at all; tests only ever run
locally, on demand.

## Setup

```bash
npm install
```

## Running the tests

There is no npm script for this — run Cypress directly:

```bash
npx cypress open   # interactive Test Runner
npx cypress run    # headless, both specs
```

Both specs hit the live `kapitalbank.az` site directly — no mocking, no
local server, no test-data isolation. `KB_mainPage_OrderCard.cy.js` in
particular is tightly coupled to the home page's current DOM structure
(`.slick-current`, `.cards-section__*`, `.fa-chevron-*`) and to which
card currently occupies the "current" carousel slot — it will break the
moment the bank's marketing carousel content or class names change.

## Known limitations (disclosed, not fixed by this pass)

- **No CI** — no `.github/workflows`, so nothing runs these tests
  automatically on push.
- **`npm test` doesn't run anything real** — it's Cypress's default
  placeholder script; must run `npx cypress` directly.
- **`package.json`'s `name` (`qa-kb`) doesn't match the repository name**
  (`QA-KB-task`).
- **`test.cy.js` isn't really a test of the site** — it only checks that
  a fixture value round-trips, and duplicates part of what
  `KB_mainPage_OrderCard.cy.js` already loads.
- **Tightly coupled to kapitalbank.az's current markup and carousel
  content** — a real production-site dependency with no versioning or
  mocking to guard against drift.
- **~22 MB repository size**, almost entirely a committed 32.6 MB (before
  compression) screen-recording, an Excel test-case sheet, and two
  screenshots — none are needed to run the automated suite; they read as
  manual-QA deliverables checked in alongside the code rather than build
  artifacts.
- **No `LICENSE` file.**
- **`npm audit` reports 11 known vulnerabilities (2 critical, 7 high, 2
  moderate)** — verified locally via `npm install` + `npm audit`, all in
  `cypress@13.5.1`'s transitive dependencies (`lodash`, `minimatch`,
  `tmp`, `uuid`, and others), not this repo's own code. Several open,
  unmerged Dependabot/Renovate branches already propose fixes for pieces
  of this (see below).
- **`master`'s actual content is older than GitHub's "last pushed" date
  suggests.** The latest commit reachable from `master` is from
  2023-12-26. GitHub reports this repo as last pushed 2026-09-15, but
  that timestamp belongs to `renovate/cypress-16.x`
  (pushed 2026-09-15T21:57:12Z) — an open, unmerged branch proposing a
  Cypress v13→v16 bump. Verified via `git merge-base --is-ancestor` for
  every remote branch: none of the seven open
  Dependabot/Renovate branches (`dependabot/npm_and_yarn/lodash-4.18.1`,
  `.../minimatch-3.1.5`, `.../multi-8ce0825ddf`, `.../multi-b54c1c9c39`,
  `.../tmp-0.2.4`, `renovate/cypress-13.x-lockfile`,
  `renovate/cypress-16.x`) are ancestors of `master` — all are routine,
  still-open dependency-bump proposals, not new work.
