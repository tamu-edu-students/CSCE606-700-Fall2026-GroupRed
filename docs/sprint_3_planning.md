# Sprint 3 (Iteration 3: Nov 13 – Nov 22, 2026)

**Status:** Agreed by the team on Nov 13.

## Sprint goal

The app looks finished and is easier to use: site-wide styling, a Messages inbox with new-message alerts, profile photos everyone can see, and new safety and profile features (pause my profile, unmatch, report a message).

## Capacity

29 story points across 6 team members (Fibonacci scale), below Sprint 2's 36 completed points. That leaves room for the review fixes and for Sprint 4's testing work to start on time.

## Team

| Lane | Member | GitHub |
| --- | --- | --- |
| A: Accounts & permissions | Colin | @cbakker207 |
| B: Testing, deploy & moderation | Jason | @jatkins11-tamu |
| C: Profiles & photos | Christopher | @cjparker-1 |
| D: Layout, Discover & matching | Zachary | @zacharydaniel229 |
| E: AI companion | Can | @Cann-E |
| F: Messaging & blocking | Sugam | @SugamM123 |

## Backlog tasks

| Issue | Title | Owner | Points | Source |
| --- | --- | --- | --- | --- |
| [#94](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/94) | Pause or hide my profile | Colin | 2 | Sprint 3 ideas |
| [#99](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/99) | Companion weekly recap of my matches and activity | Colin | 2 | Sprint 3 ideas |
| [#100](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/100) | Admin: list and search all users from the dashboard | Colin | 3 | Sprint 3 ideas (the rest of the admin idea shipped in #11) |
| [#101](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/101) | Report or delete a message | Jason | 2 | Sprint 3 ideas |
| [#103](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/103) | Show profile photos to other people, with a default when there's none | Christopher | 2 | Sprint 2 Review (fix to #34; covers Discover, My Matches, conversations and profiles) |
| [#104](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/104) | Profile prompts and interests | Christopher | 2 | Sprint 3 ideas |
| [#105](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/105) | Companion conversation coach: suggests a reply in a chat | Christopher | 3 | Sprint 3 ideas |
| [#32](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/32) | Like/pass error handling | Zachary | 2 | Carryover from Sprint 2 |
| [#106](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/106) | Messages inbox and new-message indicator | Zachary | 3 | Sprint 2 Review, plus the "new match and message alerts" idea |
| [#107](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/107) | Friendly not-authorized handling | Zachary | 1 | Sugam's retro idea; Zachary volunteered |
| [#108](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/108) | Show the companion's full profile feedback | Can | 1 | Sprint 2 Review (fix to #26) |
| [#109](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/109) | Keep the other opener ideas visible after "Use this" | Can | 1 | #85 review (fix to Can's #25) |
| [#93](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/93) | Sitewide CSS, including a tidier header with a My reports link | Sugam | 3 | Sprint 3 ideas and Sprint 2 Review |
| [#110](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/110) | Unmatch someone, with a warning that the conversation is deleted | Sugam | 2 | Sprint 3 ideas and #86 review |
| | **Total: 14 stories** | | **29** | |

Points per member: Colin 7, Jason 2, Christopher 7, Zachary 6, Can 2, Sugam 5. These bring everyone to exactly 18 points across the project; see the totals below.

**Unpointed chore:** [#102](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/102) update the README for the Sprint 2 features (it still says they are "being built"). Jason will do it as documentation upkeep rather than as a pointed story.

The team voted to keep the companion's default name as "Wingman" (4 votes), so there is no rename story. Can is the lightest this sprint, so he can pull in "Companion date ideas for a match" from the backlog once his two fixes are done.

### Project totals

| Member | Sprint 1 (done) | Sprint 2 (done) | Sprint 3 (plan) | Total |
| --- | --- | --- | --- | --- |
| Colin | 8 | 3 | 7 | 18 |
| Jason | 9 | 7 | 2 | 18 |
| Christopher | 5 | 6 | 7 | 18 |
| Zachary | 7 | 5 | 6 | 18 |
| Can | 9 | 7 | 2 | 18 |
| Sugam | 5 | 8 | 5 | 18 |
| **Team** | **43** | **36** | **29** | **108** |

## Order of work

1. **Day 1–2:** Sugam starts #93 with the shared layout and header, so later stories build on the new styles. The My reports link and Zachary's Messages link both go in the new header.
2. **Review fixes first**, since they're small and visible: photos for other people (Christopher), full companion feedback (Can) and friendly not-authorized handling (Zachary).
3. **Discover:** #32 (Zachary) and #94 (Colin) both change `SwipesController`; post a heads-up before merging, and merge `main` before opening the second PR.
4. **Conversation page:** Report a message (Jason), Unmatch (Sugam), the conversation coach (Christopher) and opener ideas (Can) all change `matches/show.html.erb`. Land them one at a time, with a heads-up in Discord.
5. Everything else can start any time; earlier is better.

## Working agreements

Carried over from Sprints 1 and 2:

- One branch per issue, named `<issue#>-short-name`; PR descriptions start with `Closes #<issue>`, get one approval, and the author merges.
- Run `bundle exec rspec && bundle exec cucumber && bin/rubocop` before pushing.
- Done means usable: tests in the same PR, the feature is reachable from the UI, and the README is updated when behavior changes.
- Pages stay server-rendered without JavaScript (ADR 0002); a `<details>` element works for a dropdown menu.

Added from the Sprint 2 retrospective:

- **PRs open by mid-sprint:** every story has a PR up by **Nov 17**.
- **Merge `main` into your branch** right before opening a PR.
- **Heads-up in Discord** before merging changes to shared files: migrations, `schema.rb`, shared models, CSS, the layout, and shared step definitions.
- **Check each story on the live Heroku site** after it merges, and mention it in the Daily Scrum on [#95](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/95).

## After Sprint 3

- **Sprint 4 (Iteration 4: Nov 23 – Dec 2):** testing and polish on the live site, no new features, plus #77 (Ruby upgrade). Final deliverables are due Dec 7, with the presentation and demo on Dec 9.
- **Backlog if time allows:** multiple profile photos, and companion date ideas.

## What we need from the team

- Reply in Discord with changes to your Sprint 3 stories by end of day Nov 13.
- Jason created the new issues (#99–#110) on Nov 13; points and Iteration 3 are set on the board.
- Each owner adds a "Done when" checklist to their issues before starting.

## Planning history

- **Nov 12:** Sprint 2 Review and Retrospective held. The review found photos not showing to other users, truncated companion feedback, no Messages link or new-message notice, no My reports link, and a crowded header.
- **Nov 12:** Colin created #93 (Sitewide CSS, assigned to Sugam) and #94 (Pause or hide my profile); Jason created #95 (Sprint 3 Daily Scrum Log).
- **Nov 13:** Jason drafted this plan from the Sprint 2 plan's Sprint 3 ideas, the Sprint 2 Review feedback and the retro, keeping project totals even. The team agreed to the plan and voted to keep the companion name "Wingman".
