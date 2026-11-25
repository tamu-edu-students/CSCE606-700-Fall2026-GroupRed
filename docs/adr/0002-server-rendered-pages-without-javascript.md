# ADR 0002: Server-rendered pages that work without JavaScript

**Status:** Accepted (Sprint 1); updated to document the current implementation.

## Context

The course requires the interface to work with JavaScript disabled and meet accessibility requirements.

The application needs account management, profile browsing, messaging and AI assistance without depending on a JavaScript frontend.

## Decision

Rails renders pages using ERB templates. Navigation uses ordinary links, and user-submitted changes use HTML forms through helpers such as `button_to` and `form_with`.

Authentication, authorization and validation happen on the server. Browser validation is an additional convenience, not the only validation.

After form submissions, controllers either render validation errors or redirect to the next page. Native URL fragments can return users to a specific part of a page without JavaScript.

The account menu uses native HTML `details` and `summary` elements.

## Conversations and AI

Messages are loaded when the conversation page is requested. There are no live message subscriptions or automatic incoming-message updates.

Users send a message or refresh the page to see new replies.

AI calls run during the web request. The API client has a 10-second timeout and no retries, as described in ADR 0001. The timeout limits the API wait; it is not a guarantee about the total duration of the web request.

Generated openers and reply suggestions fill an editable draft. The user submits the message form to send it.

## Confirmations

Required warnings must be available without JavaScript.

Unmatch already uses a separate confirmation page with an explanation, an Unmatch button and a Cancel link.

Some existing Block and Delete buttons still contain `turbo_confirm` attributes. The current JavaScript entry point does not import Turbo, so these attributes alone do not provide confirmation dialogs. Replacing these with working confirmations is tracked in issue #142.

## Testing

Most acceptance tests use Capybara's `rack_test` driver. These tests exercise server-rendered forms, redirects and page content without executing JavaScript.

The axe accessibility system test uses a real browser. Browser walkthroughs are also needed to check keyboard navigation, focus, scrolling and behavior with JavaScript disabled. Passing a redirect assertion alone does not verify the browser's scroll position.

## Consequences

- Core flows remain usable without a JavaScript frontend.
- Form submissions normally reload or navigate to another page.
- Incoming messages require a refresh.
- AI requests keep the user waiting until a response or fallback is returned.
- New interactive features must provide a server-rendered path when JavaScript is unavailable.

## References

- [Routes](../../config/routes.rb)
- [Application layout](../../app/views/layouts/application.html.erb)
- [JavaScript entry point](../../app/javascript/application.js)
- [Import map](../../config/importmap.rb)
- [Unmatch confirmation](../../app/views/matches/unmatch.html.erb)
- [AI service decision](0001-route-ai-calls-through-companion-service.md)
- [Confirmation follow-up: issue #142](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/issues/142)
