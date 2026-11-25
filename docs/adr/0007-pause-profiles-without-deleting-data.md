# ADR 0007: Pause profiles without deleting their data

**Status:** Implemented for Discover; the swipe-history extension is tracked in #135.

## Context

Users need a temporary break from discovery while keeping their profile, matches and conversations.

This requires a reversible visibility setting separate from profile deletion or an administrator suspending an account.

## Decision

Store the setting in `profiles.paused`, a non-null boolean that defaults to `false`.

The profile owner uses Pause profile or Unpause profile to update this setting through the existing profile update action.

Pausing preserves the profile and its associated data. It does not change the account's `suspended_at` value.

### Current behavior

- Discover selects prospects whose `paused` value is `false`.
- The new-swipe action also rejects a paused target, including a directly submitted request.
- Existing matches and conversations remain available, subject to their normal access checks.
- Direct profile pages and swipe history do not currently filter profiles by their paused state.

### Planned swipe-history behavior

The team voted to hide paused profiles from other people's swipe history while paused and show them again after unpausing.

Issue #135 tracks that change and a visible "Your profile is paused" note. These are follow-up work, not behavior already provided by the original pause implementation.

## Consequences

- Users can pause and resume without rebuilding their profile.
- Existing matches and messages are retained.
- Each listing must apply the intended visibility rule explicitly.
- Documentation and live checks need updating when the swipe-history extension lands.

## References

- [Paused-state migration](../../db/migrate/20261121015832_add_paused_to_profiles.rb)
- [Profile controller](../../app/controllers/profiles_controller.rb)
- [Discover and swipe-history controller](../../app/controllers/swipes_controller.rb)
- [Profile viewing controller](../../app/controllers/people_controller.rb)
- [Pause and admin polish: issue #135](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/135)
- [Data model](../data-model.md)
