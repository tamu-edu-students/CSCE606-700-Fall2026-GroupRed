# README user guide check

**Date:** November 25, 2026

**Checked by:** Christopher Parker

**Site:** https://wingmain-427a5124258b.herokuapp.com

## Scope

Walked through the live site as Kara Zor-El and as an administrator.
Compared page names, navigation, visible controls and content with the
README user guide. Screenshots were reviewed, and admin email search
was exercised.

This was a documentation walkthrough, not a full regression test.

## Observations

| Area | Observed on the live site |
| --- | --- |
| Navigation | Discover, Matches, Companion, Conversations, Account and Sign out are visible. |
| Account menu | Profile, Blocked people, My reports and Account settings are available to Kara. |
| Profile | Photo, bio, both prompt answers, interests and full saved companion feedback are displayed. |
| Profile controls | What do you think?, Edit profile, Pause profile and Delete profile are visible. |
| Edit profile | Optional prompts and interests, preferences, Photo, Photo alt text and Save profile are present. |
| Conversations inbox | Peter's conversation shows total and unread message counts, with Open conversation. |
| Conversation page | Incoming messages have Report; outgoing messages have Delete. Help me start, Suggest a reply and Send are present. |
| Unmatch | The link opens a separate warning page explaining that the conversation is deleted for both people and cannot be restored. Unmatch and Cancel are available. |
| Companion | Customize Wingman and the My week recap are displayed. |
| Companion customization | Name, Personality and Save companion are present. |
| Discover | Profile information, Wingman says, Report this reply, chat Send, Like, Pass, Undo Last Swipe and View Swipe History are visible. |
| Swipe history | Liked and Passed sections include View and Change Decision controls. |
| History profile popup | Peter's photo, bio, prompt answers and interests appear, with a Close button. |
| Matches | Cards include Message &lt;name&gt; and View &lt;name&gt;'s profile links. |
| Another person's profile | Block &lt;name&gt; and Report &lt;name&gt; controls are visible. |
| Report form | Reason, Submit report and a link back to the profile are present. |
| Blocked people and My reports | Both pages load and show clear empty states for Kara. |
| Admin dashboard | All Users, Open reports and Banned accounts are displayed, with Ban, Dismiss report and Pardon controls. |
| Admin search | Searching for kara.zorel@wingmain.test returns Kara's account. |

## Documentation findings

The README inspected during this walkthrough was missing:

- Conversations navigation and inbox instructions.
- Pause and unpause instructions.
- Unmatch instructions and its warning.
- The My week recap.
- The admin All Users list and search.

These additions are covered by [PR #149](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/pull/149),
which addresses [issue #119](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/119).

Use **Matches** consistently in the guide; that is the live page name.

The admin search label currently says **Search users by name**, but email
search also works. The label update is tracked in
[issue #135](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/135).

## Verification limits

This walkthrough did not test destructive actions, unread-count changes,
validation limits, keyboard accessibility, mobile layouts or behavior
with JavaScript disabled. Visible controls alone do not verify those behaviors.
