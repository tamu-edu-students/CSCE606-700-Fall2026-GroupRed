# Sprint 1 Review

**Sprint:** Iteration 1 (Oct 24 – Nov 2, 2026)
**Date held:** Nov 2, 2026, 7:00–7:20 pm CT, Discord call
**Attended:** Jason, Colin, Zachary, Sugam (Christopher and Can absent)
**Presented by:** Jason demoed all features on the live Heroku site; the team discussed how each one works.
**Stakeholders:** No TA or instructor attended. Colin emailed Dr. Ritchey on Oct 30, 2026 about attendance; he replied on Nov 2, 2026 that the instructor/TA presence requirement is usually waived for the online section, and suggested contacting our TA (Peiman) to attend future reviews over Zoom.

## Sprint goal

> Deliver a deployed, tested foundation for the mid-project deliverable (Nov 2): users can register, sign in, create a profile, browse and like/pass on profiles, and meet their AI companion. CI enforces tests, 90% coverage and RuboCop on every PR, and main auto-deploys to Heroku.

**Result: Met.** Every planned item is done and deployed to Heroku, and we pulled in extra work during the sprint. The review found two gaps on the live site (see Demo notes and Adjustments below).

## Progress towards product goal

### Planned work (28 points, all done)

| Issue | Story | Owner | Points | PR |
|---|---|---|---|---|
| #5 | Initialize devise and user model | Colin | 3 | #21 |
| #18 | Implement registration | Colin | 2 | #45 |
| #19 | Validate registration | Colin | 1 | #56 |
| #20 | Sign in/out | Colin | 2 | #53 |
| #27 | Testing setup and CI | Jason | 2 | #39 |
| #28 | Heroku deploy | Jason | 2 | #38 |
| #30 | Seed data | Jason | 1 | #42 |
| #6 | Create/View/Edit Profile | Christopher | 3 | #41 |
| #12 | Profile setup error handling | Christopher | 2 | #43 |
| #29 | Shared layout and accessibility baseline | Zachary | 2 | #65 |
| #7 | Like or Pass Profiles | Zachary | 3 | #47 |
| #22 | Meet my companion | Can | 3 | #37 |
| #16 | AI personalization | Sugam | 2 | #54 |

### Pulled in during the sprint (15 points)

| Issue | Story | Owner | Points | PR |
|---|---|---|---|---|
| #10 | Block Users | Sugam | 3 | #46 |
| #23 | Companion reacts to profiles | Can | 3 | #57 |
| #24 | Chat with my companion about a profile | Can | 3 | #58 |
| #33 | My Matches list | Zachary | 2 | #55 |
| #48 | Check RSpec and Cucumber coverage separately in CI | Jason | 1 | #49 |
| #51 | Write technical documentation and user guide | Jason | 2 | #52 |
| #59 | Update README for Sprint 1 features | Jason | 1 | #60 |

**Velocity:** 43 points completed against 28 planned (see the Iteration 1 burnup on the project board).

| Member | Points |
|---|---|
| Colin | 8 |
| Jason | 9 |
| Christopher | 5 |
| Zachary | 7 |
| Can | 9 |
| Sugam | 5 |

### Quality at the end of the sprint
- CI runs RSpec, Cucumber and RuboCop on every PR and requires at least 90% coverage for RSpec, Cucumber and both combined.
- Branch protection on `main`: 1 approval and passing CI required.
- `main` auto-deploys to Heroku after CI passes; the release phase runs migrations.
- Accessibility baseline: skip link, landmarks, live-region flash messages, and an automated axe check in CI (#65).
- Cucumber scenarios shortened to 8 steps or fewer (#66, #67).
- Process docs added: Definition of Done, ADRs 0001–0003, a postmortem and debugging pointers (#64).

### Demo (live on Heroku, seeded demo accounts; presented by Jason)

| Order | Feature (owner) | What we showed | Feedback / notes |
|---|---|---|---|
| 1 | Accounts (Colin) | Sign up with an under-18 birthdate (error), then a valid sign-up; sign in/out | No changes requested |
| 2 | Profiles (Christopher) | Create, view and edit a profile on the newly registered account; validation error | No changes requested |
| 3 | Layout, Discover and matching (Zachary) | Header nav and skip link; Discover like/pass and "It's a match!"; My Matches list | Rename "Dislike" to "Pass"; add a way to see past likes and passes (#70) |
| 4 | AI companion (Can) | Meet my companion; reactions; chat | The companion replied with its fallback "taking a break" message because no AI API key is configured on Heroku yet; the fallback worked as designed (#68) |
| 5 | Customization and blocking (Sugam) | Companion customization; Blocked people list and unblock | There is no way to block a user from the UI; blocking was tested with direct URLs. The Blocked people list and unblock work (#69). |
| 6 | Testing, deploy and process (Jason) | CI checks, auto-deploy, seed data, board and burnup | No changes requested |

### What's not done yet (toward the product goal)
- Messaging between matches (#8, #14)
- Profile photo (#34)
- Pundit permissions and admin role (#31), reporting (#35, #36) and moderation (#11)
- Discover filtered by preferences (#13) and hiding blocked/suspended users (#17)
- AI error handling (#15) and new companion features (#25, #26)

## Adjustments to product backlog

- **New from the Sprint Review:**
  - #68: Configure a real AI API key on Heroku so the companion gives live responses (currently shows the "taking a break" fallback).
  - #69: Add a Block button to the UI; blocking currently only works through a direct URL.
  - #70: Rename "Dislike" to "Pass" and view my past likes and passes (friendlier wording that matches #7's title; no way to see or undo earlier swipes).
- **New issues from Sprint 1:**
  - #61: Deleting an account with a match fails.
  - #62: Delete profile (full CRUD).
- **Carryover / cleanup:**
  - Sugam's "Unblock someone" scenario shortened to 8 steps and comment typos fixed (#67).
  - The home page still duplicates the header navigation links (found while reviewing #65). Remove them and update the sign in/out Cucumber steps.
  - Extend the axe accessibility test to signed-in pages (profile, Discover, companion).
- **Next up for Sprint 2 (Iteration 2, Nov 3–12):** first configure the AI API key on Heroku (#68) and add a Block button to the UI (#69), then start the stories others depend on: Pundit (#31), messaging (#8) and profile photo (#34). Group dependent stories under one owner or pair (see the retrospective).