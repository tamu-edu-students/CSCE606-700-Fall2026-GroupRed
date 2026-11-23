# Sprint 3 Retrospective

**Sprint:** Iteration 3 (Nov 13 – Nov 22, 2026)
**Format:** Members answered four questions in the team Discord group DM before the Sprint 3 Review, and we discussed them on the review call on Nov 22. The questions were: what went well, one thing to change for Sprint 4, anything you got stuck on or waited on, and what to test or fix first in Sprint 4.
**Result:** 27 of 29 planned points done (12 of 14 stories); #108 and #109 move to Sprint 4.

## Answers by member

| Member | What went well | One change for Sprint 4 | Stuck on or waited on | Test or fix first in Sprint 4 |
|---|---|---|---|---|
| Jason | Reviews stayed fast, PRs came in earlier than Sprint 2, and agreeing on merge order kept conflicts small. My two items (#101, #102) were done by Nov 17. | Post a short status at least every other day, even "no progress yet," so we're not guessing who's blocked. | A local Chrome/Selenium mismatch broke the accessibility spec on my Mac (CI was fine), and the README had to catch up on Sprint 2 features. | Run the full demo flow on the live site with clean demo data (testing changed it again this sprint), and check the no-JS confirmations Sugam found. |
| Christopher | Finished #104 and #105, and the reviews helped get them merged quickly. Testing on the live site confirmed users could edit and send suggested replies. | Test on the live site earlier, especially the AI features; automated tests passed, but live testing caught a wording issue. | The companion sometimes gave advice instead of writing a reply from the user's point of view; fixed in #116 and checked live. | Walk through the full demo flow together (create a profile, match, message, use the companion); check how the new features work together, plus mobile layout, keyboard navigation and JavaScript disabled. |
| Colin | No merge conflicts. | Nothing to change; things are going well. | Nothing. | Go through the final demo requirements and test that we meet all of them (4 client/problem-specific features, accessibility, responsive design, navigation, performance, JavaScript disabled, security/data protection); also make sure everyone has the same total story points before the individual deliverables. |
| Zachary | No CI or testing issues. | Merge as soon as a PR is approved, so merge conflicts can be handled locally. | A couple of merge conflicts, handled quickly. | Go through the requirements and make sure all are handled. |
| Can | No answer received. | — | — | — |
| Sugam | — | Test on Heroku right after merging. | Merging around shared files (`swipes/index.html.erb`, `matches/show.html.erb`) and catching a couple of no-JS / CI issues (`turbo_confirm` without Turbo, a global `Match.count` in Cucumber). | Wrap up the remaining open items (#107, #108, #109, #119, #77), fix broken `turbo_confirm` prompts (Block, Delete message/profile), and run a full live Heroku walkthrough on mobile and with JavaScript off. |

## Follow-up on Sprint 2 changes

| Sprint 2 change | Did we do it? |
|---|---|
| Open each story's PR by mid-sprint (Nov 17) | **Better, not fully.** 7 of the 12 finished stories had PRs up by Nov 17 (in Sprint 2, about half of all PRs merged in the last two days). The other 5 (#110, #94, #106, #99, #107) still came in during the last three days, and two stories never got a PR. |
| Merge main into your branch right before opening a PR | **Yes.** Most PRs merged main first; the two `schema.rb` version conflicts (#125/#126, and #127) were resolved cleanly by merging in an agreed order. |
| Heads-up in Discord before merging changes to shared files | **Yes.** Heads-ups went out for the conversation page, `CompanionService`, `routes.rb` and each new migration (#101, #104, #105, #125, #127). |
| Check each story on the live Heroku site after it merges | **Mostly.** Christopher checked every one of his stories live, which caught the conversation coach giving advice instead of a ready-to-send reply (fixed in #116); Jason checked #101 live. Not everyone posted a live check. |

## How the sprint went

### Individuals and interactions
- Five of six members finished all of their Sprint 3 stories; Christopher finished all three by Nov 16.
- Reviews stayed fast; most PRs got a first review the same day, and several review notes were taken before merging (blocked users in the recap, unused routes, existing messages marked read).
- Can didn't post updates until the last day of the sprint (Nov 22), when he checked in and planned to finish his two small companion fixes (#108, #109) on Nov 24.
- Several members were traveling or had limited availability, and still kept their stories moving.

### Processes
- PRs came in earlier than in Sprint 2, but the last three days still held five stories and three migrations.
- Agreeing on merge order (e.g. #97 before #112, #125 before #126) kept conflicts small and easy to resolve.
- Live testing found a real problem tests couldn't (#105's prompt), and the fix shipped the same day.
- #93 started without a "Done when" checklist and needed an extra round of UI feedback; stories with a checklist mostly passed review in one round.

### Tools
- Dependabot kept dependencies current (#121–#124), including the Anthropic SDK and the S3 client.
- GitHub's new PR Overview page made it easier to see what each PR was waiting on.
- A local Chrome/Selenium mismatch broke the accessibility spec on one Mac; CI was unaffected.

### Definition of Done
- Every merged story had RSpec and Cucumber tests and passed CI with 90%+ coverage before merging.
- README updates were inconsistent: Christopher's PRs updated the user guide, most others didn't, so a README pass is a Sprint 4 chore again.

## What went well
- 27 of 29 points done, and five of six members finished everything.
- PRs opened earlier than in Sprint 2, and heads-ups about shared files prevented most conflicts.
- Fast, specific reviews; fixes from review comments landed before merging.
- Live testing caught and fixed a real issue the same day.
- Every Sprint 2 Review complaint was addressed: photos for everyone, full Messages inbox with unread count, My reports link, tidier header.

## Problems encountered
- Five stories still landed in the last three days of the sprint.
- Two stories (#108, #109) were never started, with no status updates.
- README updates weren't made in most PRs.
- Several migrations close together caused `schema.rb` version conflicts.
- A few gaps showed up only in the live demo: the conversation page jumping to the top after Send, paused profiles still showing in swipe history, and an out-of-date search label.

## Changes for Sprint 4

| Change | Why | How we'll check |
|---|---|---|
| Post a short status at least every other day, even "no progress yet" | Two stories went the whole sprint without an update | Every member appears in the Daily Scrum log at least every other day |
| Update the README user guide in the same PR as any user-facing change | Most Sprint 3 PRs skipped it, so we need a catch-up chore again | Reviewers ask for it before approving |
| Write a "Done when" checklist before starting a story | #93 started without one and needed an extra review round | Every Sprint 4 issue has a checklist before it moves to In progress |
| Check every merged story on the live Heroku site the same day, AI features especially | Christopher and Sugam; live testing caught the #105 wording issue that tests missed | The Daily Scrum mentions the live check for each merged story |
| Merge a PR as soon as it's approved and CI is green | Zachary; PRs sitting approved led to more merge conflicts | Approved PRs don't wait more than a day to merge |
| Test against the final demo requirements checklist | Colin; the final demo is graded on specific requirements (features, accessibility, responsive design, navigation, performance, no-JS, security) | Each requirement has an owner and a pass/fail note before Dec 7 |
