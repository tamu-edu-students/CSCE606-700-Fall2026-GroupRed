# ADR 0003: Enforce coverage per test suite in CI

**Status:** Accepted (Sprint 1)

## Context

The course requires at least 90% line coverage from Cucumber alone, from RSpec alone, and from both combined. Six people merge to `main` daily, so checking this by hand isn't reliable.

## Decision

CI runs each suite into its own coverage folder (`COVERAGE_DIR=coverage/rspec`, `coverage/cucumber`), runs both together for the total, and fails if any of the three is below 90%. It also runs RuboCop. `main` is protected by a ruleset: changes need a pull request, one approval, and a passing `test` check. Heroku only deploys `main` after CI passes.

## Consequences

- Every feature needs Cucumber scenarios, not just RSpec, or the Cucumber-only number drops.
- The suites run twice in CI, adding a few seconds.
- Because branches don't have to be up to date before merging, two PRs can pass separately and fail together on `main` (see the Oct 30 postmortem). The team accepted that trade-off over forcing every PR to update its branch whenever `main` changes.