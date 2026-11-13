# Sprint 1 Retrospective

**Sprint:** Iteration 1 (Oct 24 – Nov 2, 2026)
**Format:** Async in the team Discord group DM; each member answered three questions (what went well, problems, one change for Sprint 2).
**Result:** All planned Iteration 1 items done (28 points), plus 15 points pulled in mid-sprint (#10, #23, #24, #33, #48, #51, #59), for 43 points total.

## Answers by member

| Member | What went well | Problems encountered | One change for Sprint 2 |
|---|---|---|---|
| Christopher | Profile validation work was completed and merged; the team reviewed PRs quickly. | Some Cucumber scenarios were over the 8-step limit (fixed in #66; all tests passing). | Catch test and style requirements earlier, before opening PRs. |
| Colin | GitHub Projects tracked progress and generated the burnup chart; the CI workflow ran tests and helped keep bad code off main. | Issues sometimes didn't appear on the project board (resolved on its own); some weak tests passed CI and were caught in PR review (#56). | Start earlier so PRs aren't rushed at the end of the sprint. |
| Jason | Everyone was willing to take on what was asked without complaint, and people asked questions when they were unsure. | Scheduling a live Daily Scrum: finding 15 minutes a day for six people was harder than expected, so we switched to async check-ins in Discord. | During planning, identify the small setup items that block other work (like the User model, testing setup and seed data in Sprint 1) and finish those first. |
| Sugam | Almost all Sprint 1 stories merged on time; PR reviews and communication in Discord were fast and helpful. | Waiting on prerequisite setup and models before starting dependent features; a few merge conflicts and minor test/comment cleanups at the end, resolved through PR reviews and quick follow-up fixes. | Group dependent stories and assign them to the same person (or pair) so no one is blocked waiting on another story to merge. |
| Can | All three companion stories were merged; reviews were quick, and CI caught problems before merging. | Everyone was blocked at the start waiting on the User model (solved once Devise merged); local setup issues with PostgreSQL on Windows (fixed). | Check Discord and GitHub more often so PRs don't sit waiting on reviews. |
| Zachary | All tasks were completed on time, and everyone was responsive when issues came up. | Tests for one feature ended up on a different branch, which blocked others when main's coverage check failed; quickly pushed the tests (#55) to unblock everyone. | Make sure everyone knows who is blocking them and who they are blocking, so the right people know which tasks to finish first. |

## How the sprint went

### Individuals and interactions
- Everyone took on the work asked of them, was responsive when issues came up, and asked questions when unsure.
- PR reviews were fast, and communication in Discord was quick and helpful.
- A live 15-minute Daily Scrum was hard to schedule for six people, so we switched to async check-ins in Discord, consolidated into one entry per day on #50.
- Work was back-loaded: much of Iteration 1 merged in the last three days (Oct 29–31).

### Processes
- Branch protection (1 approval + passing CI) meant nothing reached main unreviewed.
- PR review caught problems CI couldn't, such as request specs that passed without actually testing the invalid input (#56).
- A few setup items (User model #5, testing setup #27, seed data #30) blocked other lanes until they merged.
- Dependent stories were split across different people, and it wasn't always clear who was waiting on whom.
- Several PRs merged without `Closes #N` (#38, #47, #55), so issues had to be linked to their PRs by hand.

### Tools
- GitHub Projects with iterations, points and burnup charts gave a clear view of progress.
- CI enforced 90% coverage separately for RSpec, Cucumber and total and caught problems before merge; main briefly failed the Cucumber-only check when a feature's tests landed on a different branch than the feature (fixed by #55; see `docs/postmortems/2026-10-30-main-failed-cucumber-coverage.md`).
- Issues added to the board didn't always show up right away.
- Local setup on Windows (PostgreSQL) took extra time to get working.

### Definition of Done
- Most stories met the Definition of Done (`docs/definition_of_done.md`) at merge.
- Misses were caught after merge: a feature merged before its tests (#55), Cucumber scenarios over 8 steps, and small comment typos (fixed in #66 and #67).

## What went well
- Every planned Iteration 1 item was finished on time.
- Team members took on their work willingly, stayed responsive, and asked questions when needed.
- Fast PR reviews and helpful communication in Discord.
- CI and branch protection kept main deployable; Heroku auto-deploys after CI passes.
- The board and burnup charts made progress easy to see.

## Problems encountered
- A live Daily Scrum was hard to schedule for six people (solved by going async).
- Setup items and prerequisite stories blocked other lanes early in the sprint, and dependencies between people weren't always visible.
- A feature's tests were on a separate branch, so main's coverage check failed and blocked others until #55 merged.
- Work bunched up at the end of the sprint, which led to a few merge conflicts.
- Some PRs sat waiting on reviews.
- Some tests passed CI without really testing the behavior; review caught them.
- Course rules (8-step scenarios, commit message format, `Closes #N`) were sometimes checked only after merge.
- Local setup issues (PostgreSQL on Windows) and a project board that was sometimes slow to show new issues.

## Changes for Sprint 2

| Change | Why | How we'll check |
|---|---|---|
| Identify blocking setup items during planning and finish them first | Jason; #5, #27 and #30 held up other lanes in Sprint 1 | Sprint 2 plan lists blockers first; Daily Scrum blockers clear within a day |
| Assign dependent stories to the same person or pair | Sugam; members waited on each other's PRs | Sprint 2 plan groups related stories (e.g. #31 → #11/#35, #8 → #14) under one owner or pair |
| Make dependencies visible: mark "blocked by" on issues and name who you're waiting on in the Daily Scrum | Zachary; people didn't always know who they were blocking | Issues show "blocked by" links; Daily Scrum Blockers column names the issue and person |
| Open PRs earlier in the sprint, not in the last few days | Colin; work was back-loaded and caused merge conflicts | Burnup shows steady progress, not a jump at the end |
| Check Discord and GitHub at least daily so PRs don't wait on reviews | Can | PRs get a first review within a day of opening |
| Check test and style rules before opening a PR: tests in the same PR as the feature, scenarios ≤ 8 steps, happy and sad paths, commit format, `Closes #N` | Christopher; Zachary | Reviewers check these items in the PR template |
| Reviewers check that tests actually test the behavior, not only that CI is green | Colin; #56 | Called out in review comments |