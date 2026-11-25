# ADR 0001: Route all AI calls through CompanionService

**Status:** Accepted (Sprint 1); updated to document the current implementation.

## Context

The AI companion now supports greetings, profile reactions, chat, opener ideas, profile feedback, reply suggestions and weekly recaps.

API calls cost money, may be slow or fail, and produce different responses each time. Keeping these calls in one service gives the application a shared place for prompt construction, API configuration and failure handling.

## Decision

All calls to Anthropic go through `CompanionService`. Controllers call feature methods rather than the API client directly.

### Context sent to the AI

- Profile context includes display name, calculated age, gender, bio, prompt answers and interests.
- Companion chat includes the conversation history about the selected profile and the user's new message.
- Reply suggestions include the match's profile and the latest 10 match messages, ordered oldest first.
- Profile feedback includes whether a photo is attached, without sending the photo file.
- Weekly recaps include recent match names, the number of likes given, and names of matches whose latest message needs a response.
- The system prompt includes the companion's name and personality.

Account email and date-of-birth fields are not added to these prompts. This is a field-selection rule, not automatic redaction of information users type into profile text or messages.

### Failure handling

The API client uses a 10-second timeout and no retries.

`ask` returns `nil` when the API key is missing, the response contains no usable text, or a handled Anthropic API error occurs. Feature methods and controllers turn that result into the appropriate fallback message.

### Reuse and daily allowance

Greetings and profile reactions are saved for reuse. Weekly recaps are cached for the current day.

The daily allowance is 20 `CompanionMessage` records with role `user`, counted during the current day. Successful chat, opener, profile-feedback, reply-suggestion and weekly-recap requests create these entries.

Features check the allowance before generating new responses. Cached responses can still be displayed after the allowance is exhausted. Greetings and profile reactions do not create a counted user entry themselves.

### Testing

Tests stub the service or API client instead of calling Anthropic. Test setup removes the real API key; failure tests use a dummy key with a mocked client.

## Consequences

- New AI features must use the service so they share API configuration and failure handling.
- AI requests are synchronous, so the browser waits for the request to finish.
- Cached replies reduce repeat calls but can remain unchanged until their feature refreshes them.
- The daily allowance counts recorded user requests, not every individual API call.
- Automated tests verify prompt construction, failure handling and application behavior. Live checks are still needed to assess generated wording.

## References

- [Companion service](../../app/services/companion_service.rb)
- [Daily allowance](../../app/models/companion.rb)
- [Companion message validation](../../app/models/companion_message.rb)
- [AI failure tests](../../spec/requests/companion_failures_spec.rb)
- [Reply suggestion tests](../../spec/services/companion_reply_suggestion_spec.rb)
