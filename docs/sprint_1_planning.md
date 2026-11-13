# Sprint 1 (Iteration 1: Oct 24 – Nov 2, 2026)

## Sprint goal

Deliver a deployed, tested foundation for the mid-project deliverable (Nov 2): users can register, sign in, create a profile, browse and like/pass on profiles, and meet their AI companion. CI enforces tests, 90% coverage and RuboCop on every PR, and main auto-deploys to Heroku.

## Capacity

28 story points across 6 team members (Fibonacci scale).

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
| [#5](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/5) | Initialize Devise and user model | Colin | 3 |
| [#18](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/18) | Implement registration | Colin | 2 |
| [#19](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/19) | Validate registration | Colin | 1 |
| [#20](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/20) | Sign in/out | Colin | 2 |
| [#27](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/27) | Testing setup and CI | Jason | 2 |
| [#28](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/28) | Heroku deploy | Jason | 2 |
| [#30](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/30) | Seed data | Jason | 1 |
| [#6](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/6) | Create/View/Edit Profile | Christopher | 3 |
| [#12](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/12) | Profile setup error handling | Christopher | 2 |
| [#29](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/29) | Shared layout and accessibility baseline | Zachary | 2 |
| [#7](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/7) | Like or Pass Profiles | Zachary | 3 |
| [#22](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/22) | Meet my companion | Can | 3 |
| [#16](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/16) | AI personalization | Sugam | 2 |

## Order of work

1. Devise and User model (#5) first, since most stories depend on it.
2. Testing/CI (#27) and Heroku deploy (#28) in parallel, so every later PR is tested and deployed.
3. Profiles (#6) before seed data (#30) and like/pass (#7).
4. Companion (#22) before companion settings (#16).

## Working agreements

- One branch per issue, named `<issue#>-short-name`.
- Every PR description starts with `Closes #<issue>` and gets one approval; the author merges.
- Run `bundle exec rspec && bundle exec cucumber && bin/rubocop` before pushing.

## Planning history

- **Oct 21:** Colin created the repository and outlined the Scrum process: user stories as issues with story points, a Product Backlog in GitHub Projects with a Product Goal, Sprints as Project iterations, burndown charts, reviews and retrospectives.
- **Oct 22:** Zachary added the user stories from the proposal as GitHub issues (12 stories). The Product Backlog board (Project #207) was created.
- **Oct 23:** Colin set up Cucumber, PostgreSQL, CI, and the initial Heroku deploy. The team discussed how to split stories and assign points, and noted that early setup tasks (Devise, testing) blocked most other work.
- **Oct 24:** Work divided into six lanes (A–F) with roughly equal story points; each member claimed a lane. Sprint 1 (Iteration 1, Oct 24 – Nov 2) began.