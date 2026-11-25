# Sprint 3 Review

**Sprint:** Iteration 3 (Nov 13 – Nov 22, 2026)
**Date held:** Nov 22, 2026, 8:30–9:00 PM CT, Discord call
**Attended:** Jason, Christopher, Colin, Sugam and Zachary (Can was unavailable)
**Presented by:** Jason shared his screen and ran every story on the live Heroku site, naming each story's owner.
**Stakeholders:** No TA or instructor attended. As with Sprints 1 and 2, Dr. Ritchey's Nov 2 email says the instructor/TA presence requirement is usually waived for the online section.

## Sprint goal

> The app looks finished and is easier to use: site-wide styling, a Messages inbox with new-message alerts, profile photos everyone can see, and new safety and profile features (pause my profile, unmatch, report a message).

**Result: Met.** Site-wide styling with an Account menu, the Conversations inbox with an unread count, photos and profile prompts for everyone, pause my profile, unmatch with a warning, and report or delete a message are all done and deployed. 27 of 29 planned points are done; Can's two small companion fixes (#108, #109) move to Sprint 4.

## Progress towards product goal

### Done (27 points)

| Issue | Story | Owner | Points | PR |
|---|---|---|---|---|
| #94 | Pause or hide my profile | Colin | 2 | #125 |
| #99 | Companion weekly recap of my matches and activity | Colin | 2 | #127, #129 |
| #100 | Admin: list and search all users from the dashboard | Colin | 3 | #115 |
| #101 | Report or delete a message | Jason | 2 | #117 |
| #103 | Show profile photos to other people, with a default when there's none | Christopher | 2 | #97 |
| #104 | Profile prompts and interests | Christopher | 2 | #113 |
| #105 | Companion conversation coach: suggests a reply in a chat | Christopher | 3 | #114, #116 |
| #32 | Like/pass error handling (carried over from Sprint 2) | Zachary | 2 | #98 |
| #106 | Messages inbox and new-message indicator | Zachary | 3 | #126 |
| #107 | Friendly not-authorized handling | Zachary | 1 | #128 |
| #93 | Sitewide CSS, including a tidier header with a My reports link | Sugam | 3 | #112 |
| #110 | Unmatch someone, with a warning that the conversation is deleted | Sugam | 2 | #120 |

### Not finished (2 points, moving to Sprint 4)

| Issue | Story | Owner | Points | Status |
|---|---|---|---|---|
| #108 | Show the companion's full profile feedback | Can | 1 | Not started |
| #109 | Keep the other opener ideas visible after "Use this" | Can | 1 | Not started |

**Velocity:** 27 points completed against 29 planned (Sprint 1: 43, Sprint 2: 36). See the Iteration 3 burnup on the project board.

| Member | Planned | Done |
|---|---|---|
| Colin | 7 | 7 |
| Jason | 2 | 2 |
| Christopher | 7 | 7 |
| Zachary | 6 | 6 |
| Can | 2 | 0 |
| Sugam | 5 | 5 |
| **Team** | **29** | **27** |

Unpointed work also merged this sprint: the README update for Sprint 2 features (#102, PR #118), the Sprint 3 planning doc (#111), a follow-up prompt fix for the conversation coach (#116), a recap fix hiding blocked and banned people (#129), and Dependabot updates #121–#124 (thruster, puma, anthropic, aws-sdk-s3).

### Quality at the end of the sprint
- CI still runs RSpec, Cucumber and RuboCop on every PR with 90% coverage required per suite.
- Three migrations this sprint (`profiles` prompts and `paused`, `messages.seen`, `companions.weekly_recap`), all safe defaults, run automatically by Heroku's release phase.
- Blocked and banned users are now excluded everywhere new data appears: the Conversations list and unread count, the weekly recap, and the admin dashboard.
- The companion stays within its 20-requests-a-day limit for every new AI feature (conversation coach, weekly recap), with the friendly fallback when the AI is unavailable.
- Every new page works without JavaScript (ADR 0002), including the Account menu (`<details>`) and the unmatch confirmation page.

### Demo (live on Heroku)

| Order | Feature (owner) | What we showed | Feedback / notes |
|---|---|---|---|
| 1 | Sitewide styling (Sugam) | New styles; header with Discover, Matches, Companion, Conversations and the Account menu | Worked as expected. |
| 2 | Photos and prompts (Christopher) | Kara's photo on her profile as seen by Peter; "No photo yet." fallback; prompts and interests | Photos worked. Prompts weren't visible because the demo accounts have no answers (blank answers are hidden); the seed data should fill some in. |
| 3 | Conversations inbox (Zachary) | Kara messages Peter; Peter sees the unread count; opening the conversation clears it | Worked as expected. |
| 4 | Conversation coach (Christopher) | Suggest a reply, edit the draft, send | Worked, but the page jumps back to the top after **Suggest a reply** or **Send**, which will be awkward in long conversations. |
| 5 | Report or delete a message (Jason) | Report a message (admin sees it quoted); delete your own message | Worked as expected. |
| 6 | Unmatch (Sugam) | Unmatch warning page and Cancel; warnings on Undo and Change Decision | Worked as expected. |
| 7 | Like/pass errors (Zachary) | Clear messages for duplicate, own-profile and unavailable swipes (covered by tests) | Worked as expected. |
| 8 | Pause my profile (Colin) | Pause a profile, gone from Discover; unpause | A paused throwaway was hidden from Sky Lark's Discover. After unpausing, it still didn't appear for Sky Lark; afterward we confirmed this was the matching rules, not pause: the throwaway is a man interested in Women, and Sky Lark is non-binary, so Discover correctly never shows them to each other. Re-tested on Nov 23 with the throwaway set to "Everyone": it appeared for Sky Lark, disappeared when paused, and came back when unpaused. Paused profiles still show in swipe history and can be viewed from there. |
| 9 | Weekly recap (Colin) | "My week" on the Companion page | Worked as expected. |
| 10 | Admin user list (Colin) | All Users table, search by name and email, no Ban button on admins | Search works by name and email, but the label still says "Search by name". |
| 11 | Friendly not-authorized (Zachary) | `/admin` as a regular user redirects back with a message | #128 merged after the call, so it wasn't demoed live. |

### What's not done yet (toward the product goal)
- Show the companion's full profile feedback (#108) and keep opener ideas after "Use this" (#109)
- README user guide for the Sprint 3 features (Sprint 4 chore)
- End-to-end testing and polish on the live site (Sprint 4)

## Adjustments to product backlog

- **Carryover to Sprint 4:** #108, #109 (see above). They stay with Can, who checked in on Nov 22 and plans to finish them on Nov 24.
- **Sprint 4 chores already on the board:** #77 (upgrade Ruby and move CI to a newer runner), README update for Sprint 3 features.
- **Cleanup noted in Sprint 3 reviews:**
  - Remove the unused `not-authorized` route and `public/403.html` now that #107 redirects instead.
  - Add a weekly recap spec with a blocked or banned match.
  - Eager-load photos on My Matches (N+1) and consider resized photo variants.
  - A visible "Your profile is paused" note on the profile page.
- **New from the Sprint 3 Review demo:**
  - Keep your place in a conversation after **Send** or **Suggest a reply** (e.g. redirect to an anchor on the message form, which works without JavaScript).
  - Decide whether paused profiles should also be hidden in swipe history and from profile pages (today pausing only hides you from Discover).
  - Change the admin search label to "Search by name or email".
  - Seed some prompt answers so the demo accounts show them.
- **Next up: Sprint 4 (Iteration 4, Nov 23 – Dec 2):** testing and polish only, then the final deliverables (Dec 7) and the presentation and demo (Dec 9).
