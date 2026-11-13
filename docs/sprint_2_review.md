# Sprint 2 Review

**Sprint:** Iteration 2 (Nov 3 – Nov 12, 2026)
**Date held:** Nov 12, 2026, 8:00–8:45 PM CT, Discord call
**Attended:** Jason, Christopher, Colin, Can, Sugam and Zachary (Zachary joined for part of the call)
**Presented by:** Jason shared his screen and ran every story on the live Heroku site, naming each story's owner.
**Stakeholders:** No TA or instructor attended. As with Sprint 1, Dr. Ritchey's Nov 2 email says the instructor/TA presence requirement is usually waived for the online section.

## Sprint goal

> Users can message their matches safely; blocking, reporting and moderation work from the UI; profiles have photos; and the AI companion gives real responses on the live site.

**Result: Met.** Messaging, the Block button, reporting, moderation and profile photos are all done and deployed, the companion gives live AI responses on Heroku, and banned users are hidden from Discover, Matches and conversations (#17, merged on the last day). 34 of 38 planned points are done; the remaining two stories move to Sprint 3.

## Progress towards product goal

### Done (34 points)

| Issue | Story | Owner | Points | PR |
|---|---|---|---|---|
| #31 | Pundit permissions and admin role | Colin | 2 | #73 |
| #17 | Hide blocked and suspended users | Colin | 1 | #92 |
| #35 | Report a user | Jason | 3 | #74 |
| #11 | Moderate Users | Jason | 3 | #80, #82 |
| #36 | Report an AI reply | Jason | 1 | #81 |
| #34 | Profile photo | Christopher | 3 | #76 |
| #61 | Deleting an account with a match fails | Christopher | 1 | #75 |
| #62 | Delete profile | Christopher | 2 | #79 |
| #70 | Rename Dislike to Pass and view past likes/passes | Zachary | 3 | #86 |
| #15 | AI companion error handling | Can | 2 | #83 |
| #25 | Opener ideas for a match | Can | 2 | #85 |
| #26 | Companion feedback on my profile | Can | 2 | #84 |
| #68 | Configure a real AI API key on Heroku | Can | 1 | None (Heroku config var only) |
| #8 | Message Matches | Sugam | 5 | #78 |
| #14 | Only my matches can message me | Sugam | 1 | #87 |
| #69 | Add a Block button to the UI | Sugam | 2 | #88 |

### Not finished (4 points, moving to Sprint 3)

| Issue | Story | Owner | Points | Status |
|---|---|---|---|---|
| #32 | Like/pass error handling | Zachary | 2 | Not started |
| #13 | Discover shows only people who match my preferences | Zachary | 2 | Discover already filters by both people's gender and age preferences (`SwipesController#find_potential_profiles`); check against the acceptance criteria and close it if it's already met. |

**Velocity:** 34 points completed against 38 planned (Sprint 1: 43). See the Iteration 2 burnup on the project board.

| Member | Planned | Done |
|---|---|---|
| Colin | 3 | 3 |
| Jason | 7 | 7 |
| Christopher | 6 | 6 |
| Zachary | 7 | 3 |
| Can | 7 | 7 |
| Sugam | 8 | 8 |
| **Team** | **38** | **34** |

Unpointed work also merged this sprint: the Admin link in the header (#82, found while testing the live site), pinning CI to `ubuntu-24.04` after `ubuntu-latest` moved to Ubuntu 26.04 (in #74), and Dependabot updates #72, #89, #90 and #91 (including the Rails 8.1.4.1 security patch).

### Quality at the end of the sprint
- CI still runs RSpec, Cucumber and RuboCop on every PR with 90% coverage required per suite; it is pinned to `ubuntu-24.04` until we upgrade Ruby (Sprint 4 chore).
- Pundit authorization covers the admin area (#31), reports (#35, #36) and conversations (`MessagePolicy`, #14, which also refuses conversations with a suspended user after #17).
- Profile photos are stored on Amazon S3 in production through Active Storage (#34), with JPG/PNG and 5 MB limits and required alt text.
- `main` auto-deploys to Heroku after CI passes; the final Sprint 2 deploy includes every merged story and the dependency updates.
### Demo (live on Heroku)

| Order | Feature (owner) | What we showed | Feedback / notes |
|---|---|---|---|
| 1 | Admin role and permissions (Colin) | Admin-only dashboard; a regular user is refused; a banned user disappears from Discover and Matches (#17) | Worked as expected. |
| 2 | Profile photo and account cleanup (Christopher) | Upload a photo with alt text (S3); delete a profile | Peter's photo showed on his own profile but not when Kara viewed it. Other people's photos need to show, with a default "no photo" image or message when none is uploaded. |
| 3 | Pass and swipe history (Zachary) | Pass button; history of likes and passes; view a profile; change a decision; undo | Worked as expected. |
| 4 | AI companion (Can) | Live AI responses; friendly message when the AI is unavailable; opener ideas on a match; feedback on my profile | Profile feedback is cut off with "..." and there's no way to see the rest. Question raised: rename the companion's default name from "Wingman" to "WingmAIn"? |
| 5 | Messaging and blocking (Sugam) | Message a match; someone outside the match is refused; Block button on a profile; Blocked people list | Kara got no notice when Peter messaged her, and the only easy way back to the conversation was through his profile. Needs a link to all conversations (then into each one) and a new-message indicator. |
| 6 | Reporting and moderation (Jason) | Report a user and an AI reply; admin bans a user (can't sign in), dismisses a report, pardons a user; Admin link in the header | My reports has no link; it's only reachable after reporting someone or by typing /reports. Needs a link. |

### What's not done yet (toward the product goal)
- Like/pass error handling (#32) and confirming Discover preferences (#13)
- Site-wide styling (planned for early Sprint 3)
## Adjustments to product backlog

- **Carryover to Sprint 3:** #32, #13 (see above).
- **New from Sprint 2 reviews and the retro:**
  - Friendly "not authorized" handling: send people back to a normal page with a message instead of the bare `/not-authorized` 403 page (Sugam's retro idea; Zachary volunteered to own it).
  - Warn before an unmatch deletes a conversation: undo and "Change Decision" in swipe history delete the match and its messages for both people (from the #86 review).
  - Keep the other opener ideas visible after "Use this" (from the #85 review; must stay server-rendered per ADR 0002).
  - Small cleanups from reviews: `.includes(:prospect)` on swipe history, shorter opener ideas so the flash cookie can't overflow.
- **README:** the "Coming soon" section still lists messaging, photos, reporting and moderation as in progress; update the user guide for the Sprint 2 features.
- **New from the Sprint 2 Review demo:**
  - Show profile photos to other people, with a default image or message when there's no photo (fix to #34).
  - Show the companion's full profile feedback instead of cutting it off (fix to #26).
  - A Messages link in the header that lists all conversations, plus a new-message indicator (overlaps the Sprint 3 idea "New match and new message alerts").
  - A link to My reports (fix to #35).
  - Decide whether to rename the companion's default name from "Wingman" to "WingmAIn".
  - The header is getting crowded; consider grouping links or an expanding menu as part of site-wide styling (a `<details>` menu works without JavaScript, per ADR 0002).
- **Next up for Sprint 3 (Iteration 3, Nov 13–22):** finish the carryover first, then site-wide styling early so later stories build on it, then the Sprint 3 stories from the plan.
