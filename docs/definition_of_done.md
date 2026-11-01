# Definition of Done

A Product Backlog item is done when all of the following are true:

1. It has a user story (GitHub issue) with acceptance criteria.
2. It has Cucumber scenarios for both the happy and sad paths, each 3–8 steps.
3. Relevant RSpec unit tests have been added or updated.
4. All tests pass.
5. Coverage is at least 90% for Cucumber alone, RSpec alone, and the combined total (enforced by CI).
6. RuboCop reports no offenses (enforced by CI).
7. It was reviewed and approved through a pull request by at least one other team member.
8. It is deployed to production on Heroku (automatic once merged to `main` and CI passes).
9. Documentation (README, docs/) is updated if behavior, setup, or usage changed.

## Team additions

These go beyond the course's default Definition of Done, as proposed in our project proposal:

10. Every new page works with JavaScript disabled and has labeled form fields and an accessible structure (WCAG AA as the target).
11. Tests never call the real AI service: `CompanionService` is stubbed, and both test suites remove `ANTHROPIC_API_KEY`.

**Why:** the app has to work without JavaScript and meet WCAG AA anyway, so checking every feature avoids a pile of fixes at the end. Stubbing the AI keeps tests fast, free, and repeatable.