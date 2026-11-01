# ADR 0001: Route all AI calls through CompanionService

**Status:** Accepted (Sprint 1)

## Context

The AI companion greets users, reacts to profiles, and chats about them. AI replies are slow, cost money per call, and are different every time, which makes them hard to test. The proposal also promised the AI would only see profile information, never emails or birth dates.

## Decision

All calls to the Anthropic API go through one class, `CompanionService`. Controllers and models never call the API directly. The service:

- builds prompts from profile fields only (name, age, gender, bio)
- uses a 10-second timeout with no retries
- returns a friendly fallback message instead of raising when the API is down or the key is missing
- saves greetings and reactions so revisiting a page doesn't call the API again

## Consequences

- Tests stub `CompanionService` (or its `ask` method), so no test calls the real API, and both test suites also remove `ANTHROPIC_API_KEY` as a safety net.
- Privacy rules live in one place and are covered by a spec that checks no email or birth date reaches the prompt.
- Every new AI feature (openers, profile feedback) must be added to the service rather than called from a controller.