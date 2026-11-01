# ADR 0002: Server-rendered pages that work without JavaScript

**Status:** Accepted (Sprint 1)

## Context

The course requires the interface to work correctly with JavaScript disabled and to meet minimal accessibility standards (WCAG AA).

## Decision

Every page is rendered on the server with plain HTML forms and links. Actions that change data, like Like, Dislike, Block, Sign Out, and sending a companion message, are real form submissions (`button_to` / `form_with`) followed by a redirect.

## Consequences

- The whole app works with JavaScript off, and Cucumber can run on the fast default `rack_test` driver.
- There are no live updates: chatting with the companion reloads the page, and the request waits for the AI's reply. The 10-second AI timeout (ADR 0001) keeps that wait under Heroku's 30-second request limit.
- Confirmation prompts (e.g. "Block Alex?") only appear when JavaScript is on; without it, the action still works but skips the prompt.