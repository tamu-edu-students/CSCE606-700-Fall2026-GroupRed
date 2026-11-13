# Sprint 2 (Iteration 2: Nov 3 – Nov 12, 2026)

## Sprint goal

Users can message their matches safely; blocking, reporting and moderation work from the UI; profiles have photos; and the AI companion gives real responses on the live site.

## Capacity

38 story points across 6 team members (Fibonacci scale), below Sprint 1's 43 completed points. This is the whole open backlog after Sprint 1.

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

| Issue | Title | Owner | Points |
| --- | --- | --- | --- |
| [#31](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/31) | Pundit permissions and admin role | Colin | 2 |
| [#17](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/17) | Hide blocked and suspended users | Colin | 1 |
| [#35](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/35) | Report a user | Jason | 3 |
| [#11](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/11) | Moderate Users | Jason | 3 |
| [#36](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/36) | Report an AI reply | Jason | 1 |
| [#34](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/34) | Profile photo | Christopher | 3 |
| [#61](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/61) | Deleting an account with a match fails | Christopher | 1 |
| [#62](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/62) | Delete profile | Christopher | 2 |
| [#70](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/70) | Rename Dislike to Pass and view past likes/passes | Zachary | 3 |
| [#32](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/32) | Like/pass error handling | Zachary | 2 |
| [#13](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/13) | Discover shows only people who match my preferences | Zachary | 2 |
| [#68](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/68) | Configure a real AI API key on Heroku | Can | 1 |
| [#15](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/15) | AI companion error handling | Can | 2 |
| [#25](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/25) | Opener ideas for a match | Can | 2 |
| [#26](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/26) | Companion feedback on my profile | Can | 2 |
| [#69](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/69) | Add a Block button to the UI | Sugam | 2 |
| [#8](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/8) | Message Matches | Sugam | 5 |
| [#14](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/14) | Only my matches can message me | Sugam | 1 |

Points per member: Colin 3, Jason 7, Christopher 6, Zachary 7, Can 7, Sugam 8. The split was set so that Sprint 1, Sprint 2 and the Sprint 3 ideas add up to 18 points for everyone across the project.

## Order of work

1. Blockers start on day 1: Pundit and the admin role (#31), Message Matches (#8), Profile photo (#34), the AI API key (#68) and the Block button (#69).
2. #31 before Report a user (#35) and Moderate Users (#11); #35 before #11, since moderation works on reports.
3. #8 before Only my matches can message me (#14).
4. #61 and Delete profile (#62) together, since both hit the same problem with matches.
5. The suspended-user part of #17 after #11, which adds suspensions.
6. Stories with no dependency (#69, #34, #70, #25, #32, #13, #26, #36) can start any time; earlier is better.
## Working agreements

Carried over from Sprint 1:

- One branch per issue, named `<issue#>-short-name`.
- Every PR description starts with `Closes #<issue>` and gets one approval; the author merges.
- Run `bundle exec rspec && bundle exec cucumber && bin/rubocop` before pushing.
Added from the Sprint 1 retrospective:

- **Small tasks:** break each story into tasks of a day or less, as a checklist in the issue.
- **Open PRs early,** not in the last few days of the sprint.
- **Done means usable:** tests go in the same PR as the feature, and the feature must be reachable from the UI.
- **Before opening a PR:** scenarios are 8 steps or fewer with happy and sad paths, the commit subject is 50 characters or fewer with a body, and the description has `Closes #N`.
- **Reviews:** check Discord and GitHub daily and give a first review within a day.
- **Blockers:** mark "blocked by" on issues, and name who you're waiting on in the Daily Scrum on [#63](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/63).
- **Dependent stories stay with one owner:** #14 moved from Zachary to Sugam (builds on #8); #61 and #62 went to Christopher; #25 and #26 moved to Can (AI companion lane); #36 moved from Christopher to Jason (reporting, with #35 and #11).
## Planning history

- **Nov 2:** Sprint 1 Review and Retrospective held; the retro asked for blockers first, dependent stories under one owner, and earlier PRs.
- **Nov 3:** Jason drafted the Sprint 2 plan and roadmap (all 38 open backlog points in Sprint 2, Sprint 3 for new features, Sprint 4 for testing and polish) and shared it in Discord. Christopher, Colin, Zachary and Sugam reviewed and agreed.
- **Nov 4:** The team approved the plan. Jason set Iteration 2 on all 18 stories, updated owners for #14, #25, #26, #36, #61 and #62, moved them to Ready, and posted the blockers and start order to the team.
