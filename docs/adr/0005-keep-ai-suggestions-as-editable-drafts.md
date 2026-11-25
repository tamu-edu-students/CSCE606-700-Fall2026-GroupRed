# ADR 0005: Keep AI suggestions as editable drafts

**Status:** Implemented; documented during Sprint 4.

## Context

Users need help starting or continuing a conversation, but an AI response may need editing before it represents what they want to say.

Users also need to compare opener ideas without requesting new ones every time they choose a different suggestion.

## Decision

AI-generated text is placed in the message form as a draft. It is sent to the match only when the user submits the Send form.

Generating a suggestion can save companion history, but it does not create a conversation `Message`.

### Reply suggestions

`CompanionService.suggest_reply` uses the match's profile and the latest 10 conversation messages, ordered oldest first.

The prompt asks for text in the sender's voice, addressed directly to the match. It treats profile and message content as context rather than instructions.

The result is limited to `Message::MAX_LENGTH` and passed to the conversation page through the `draft` query parameter.

### Opener ideas

The service returns up to three opener ideas, each limited to 200 characters.

The session stores one set of ideas together with its match ID. The conversation page displays that set only when the stored match ID matches the current conversation.

Selecting Use this passes the chosen text through the `draft` query parameter. The other ideas remain available, and choosing another replaces the draft without another AI request.

A successful message submission clears the saved ideas for that match. A failed submission or a message sent to a different match leaves them available.

### Sending

`MatchesController` reads the draft into the form. The user can edit it before submitting.

`MessagesController` creates the conversation message after checking access and validating the submitted text.

## Consequences

- Users control the final text sent to their match.
- Selecting an existing opener does not make another AI call.
- The session retains only one match's opener set at a time.
- The opener length limit keeps the stored session payload smaller.
- Draft text is carried in the URL, rather than stored as an unsent message record.
- Prompt tests verify the instructions sent to the AI; live checks are still needed to assess generated wording.

## References

- [Companion service](../../app/services/companion_service.rb)
- [Reply suggestions controller](../../app/controllers/reply_suggestions_controller.rb)
- [Openers controller](../../app/controllers/openers_controller.rb)
- [Matches controller](../../app/controllers/matches_controller.rb)
- [Messages controller](../../app/controllers/messages_controller.rb)
- [Opener request tests](../../spec/requests/openers_spec.rb)
- [Reply suggestion request tests](../../spec/requests/reply_suggestions_spec.rb)
- [Server-rendered interface decision](0002-server-rendered-pages-without-javascript.md)
