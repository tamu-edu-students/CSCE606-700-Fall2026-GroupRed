# ADR 0006: Use matches for conversations and unread state

**Status:** Implemented; documented during Sprint 4.

## Context

Each conversation is between the two profiles in an existing match. The application needs an inbox and unread counts without introducing a second record for the same conversation.

## Decision

Use `Match` as the conversation record and `Message` for its contents. There is no separate conversations table.

### Inbox

The inbox queries matches involving the current profile that have at least one message.

It calculates message counts, unread counts and the latest message time, then orders conversations by their latest message.

Matches involving blocked or suspended accounts are excluded.

### Unread state

Each message has a non-null `seen` boolean, which defaults to `false`.

A message counts as unread for the current user when:

- It belongs to an accessible match involving their profile.
- It was sent by the other participant.
- Its `seen` value is `false`.

After checking access, opening a conversation marks incoming messages from the other participant as seen. It does not mark the current user's outgoing messages as seen.

The header counts unread messages across accessible matches. The conversation page recalculates that count after marking incoming messages as seen.

The inbox and conversation responses use `Cache-Control: no-store`.

### Existing messages

When the `seen` column was introduced, its migration marked existing messages as seen. New messages use the default value of `false`.

## Consequences

- The inbox reuses the existing match and message relationships.
- One boolean is sufficient because each message has one other participant as its recipient.
- Group conversations would require a different design to track each recipient separately.
- Unread counts update during page requests, not through live browser updates.
- Destroying a match also destroys its messages through the model association.

## References

- [Match model](../../app/models/match.rb)
- [Message model](../../app/models/message.rb)
- [Inbox controller](../../app/controllers/conversations_controller.rb)
- [Conversation controller](../../app/controllers/matches_controller.rb)
- [Header unread count](../../app/controllers/application_controller.rb)
- [Seen-state migration](../../db/migrate/20261120032930_add_seen_to_messages.rb)
- [Data model](../data-model.md)
