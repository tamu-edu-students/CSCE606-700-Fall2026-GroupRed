# Sprint 2 Retrospective

**Sprint:** Iteration 2 (Nov 3 – Nov 12, 2026)
**Format:** Members answered four questions in the team Discord group DM before the Sprint 2 Review, and we discussed them on the review call on Nov 12. The questions were: what went well, one thing to change for Sprint 3, anything you got stuck on or waited on, and feature ideas for Sprint 3.
**Result:** 36 of 38 planned points done (17 of 18 stories); #32 moves to Sprint 3.

## Answers by member

| Member | What went well | One change for Sprint 3 | Stuck on or waited on | Ideas for Sprint 3 |
|---|---|---|---|---|
| Jason | The even point split worked, and almost nobody was blocked by someone else. Reviews caught real issues before they hit main. The "reachable from the UI" lesson from Sprint 1 helped: the admin page had no link, and that was fixed before the review. | Open PRs earlier. About 8 came in during the last two days, which left little time for feedback and testing on the live site. | #35 and #11 waited a couple of days on #31; CI broke on every branch when `ubuntu-latest` moved to Ubuntu 26.04; the Heroku bucket variable was named differently than the code expected. All were fixed quickly once found. | Finish the carryover first, then site-wide styling, plus polish from this sprint's reviews: a friendly "Not authorized" page, a warning before an unmatch deletes the conversation, and opener ideas that don't reload the page. |
| Sugam | Shipped match messaging (#8), message authorization (#14) and the Block button (#69) on time; fast PR reviews and helpful feedback; got the AWS S3 bucket and IAM set up on Heroku. | Give a quick heads-up in Discord when merging migrations or shared files (`schema.rb`, Match, Profile). | Merge conflicts in shared step definitions and request specs when several PRs touched matches and openers at the same time. | Profile photo uploads (now that S3 is configured); replace the bare 403 page with friendly redirects; filter banned/suspended users out of Discover and Matches. |
| Zachary | Fewer CI issues, and the shorter sprint allowed more focused work. | Merge main into your branch before opening a PR, to avoid merge conflicts. | One merge conflict, solved easily. | More match and Discover error handling; CSS styling so the app looks nicer. |
| Christopher | His profile photo PR (#76) merged; the team helped with S3 setup and gave useful review feedback; he added Cucumber scenarios, and all tests and CI passed. | Give a quick heads-up when changing shared files, and update branches from main more often to reduce merge conflicts. | Waited on S3 configuration; had merge conflicts in the profile model, schema and step definitions. Coordinating setup and shared changes earlier would help. | Confirm photo uploads work on the live site, improve page styling, and make error messages clearer for users. |
| Colin | Everything was set up in Sprint 1, so working on tasks went a lot smoother. | Nothing; he had no problems this sprint. | Nothing blocked him; only his personal schedule. | Styling. |
| Can | Answered on the call; mostly agreed with the answers already posted. | — | — | — |

## Follow-up on Sprint 1 changes

| Sprint 1 change | Did we do it? |
|---|---|
| Identify blocking setup items during planning and finish them first | **Yes.** The Sprint 2 plan marked the blockers (#31, #8, #34, #68, #69) to start on day 1. #31 still took until Nov 6, which held up #35 and #11 for a couple of days. |
| Assign dependent stories to the same person or pair | **Yes.** #8 → #14 (Sugam), #35 → #11 → #36 (Jason) and the companion stories (Can) each stayed with one owner, and nobody was blocked by another member's dependent story. |
| Make dependencies visible in the Daily Scrum | **Mostly.** The Blockers column on #63 named who people were waiting on (e.g. #31 for #35 and #11). |
| Open PRs earlier, not in the last few days | **No.** 8 of the 15 story PRs merged on Nov 11–12, the last two days of the sprint. |
| Check Discord and GitHub daily so PRs don't wait on reviews | **Yes.** Most PRs got a first review the same day, including late in the evening. |
| Check test and style rules before opening a PR | **Mostly.** Reviews still caught a few small items (missing final newlines, typos, a missing scenario), but no rule problems reached main. |
| Reviewers check that tests actually test the behavior | **Yes.** Reviews asked for missing tests (a non-User reportable in #74, Cucumber scenarios in #76) and checked edge cases like the daily AI limit (#85). |

## How the sprint went

### Individuals and interactions
- Five of six members finished all of their Sprint 2 stories; Zachary finished two of three.
- Reviews were fast and specific; several PRs went through a "request changes, fix, approve" cycle within a day.
- Sugam was traveling for much of the sprint and still finished all three of his stories, plus the S3 and IAM setup on Heroku.
- Zachary couldn't submit reviews because he was signed into a second GitHub account; found and fixed on the last day.

### Processes
- Work was back-loaded again: about half the PRs merged in the last two days, which caused merge conflicts in shared files (CSS, step definitions, request specs) and left little time to test on the live site.
- Testing on the live site found a gap tests couldn't: the admin dashboard was only reachable by typing `/admin` (fixed by #82).
- #17 (hide suspended users) was easy to lose track of because blocked users were already hidden; it was flagged on the last day and Colin finished it that evening (#92), after addressing review comments to cover Matches and conversations too.

### Tools
- CI broke on every branch on Nov 8 when GitHub moved `ubuntu-latest` to Ubuntu 26.04, which doesn't have Ruby 3.4.5. We pinned CI to `ubuntu-24.04` in #74 and added a Sprint 4 chore to upgrade Ruby and unpin.
- The Heroku config var for the S3 bucket was named `AWS_BUCKET` while the code reads `AWS_S3_BUCKET`; renamed on Heroku.
- Dependabot kept dependencies current, including a Rails security patch (#91).

### Definition of Done
- Every merged story had RSpec and Cucumber tests in the same PR, passed CI with 90%+ coverage, and was reviewed before merging.
- Every Sprint 2 feature is reachable from the UI, which was a Sprint 1 miss (Block, #10).

## What went well
- 36 of 38 points done, with the work spread evenly across the team.
- Grouping dependent stories under one owner meant almost nobody waited on another member.
- Fast, thorough reviews caught real problems before they reached main.
- Every feature is reachable from the UI and deployed on Heroku.
- S3 photo storage and a live AI key are set up in production.

## Problems encountered
- About half the PRs merged in the last two days of the sprint.
- Merge conflicts in shared files when several PRs touched the same area.
- CI broke on every branch after a GitHub runner change.
- A Heroku config var name didn't match the code.
- #17 wasn't flagged until the last day of the sprint.
- One member couldn't review because of a second GitHub account.

## Changes for Sprint 3

| Change | Why | How we'll check |
|---|---|---|
| Open each story's PR by mid-sprint (Nov 17) | Jason; repeated from Sprint 1 and still not met | The burnup shows steady progress; few PRs merge on the last two days |
| Merge main into your branch right before opening a PR | Zachary; avoids merge conflicts at review time | PRs show no conflicts when review starts |
| Post a heads-up in Discord before merging changes to shared files (migrations, `schema.rb`, shared models, CSS, shared step definitions) | Sugam; conflicts in shared files | Heads-ups appear in Discord; fewer conflicts |
| Check each story on the live Heroku site after it merges | The admin link (#82) was only found by testing the live site | The Daily Scrum mentions the live check for each merged story |
