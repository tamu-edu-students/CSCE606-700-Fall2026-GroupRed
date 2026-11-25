# ADR 0003: Enforce coverage per test suite in CI

**Status:** Accepted (Sprint 1); updated to document the current CI setup.

## Context

The course requires at least 90% line coverage from RSpec alone, Cucumber alone, and both suites combined.

Multiple teammates work on separate branches. Automated checks provide a consistent way to validate changes before merging.

## Decision

GitHub Actions runs on pull requests and pushes to `main`. It sets up Ruby, PostgreSQL 16 and Chrome.

### Test database

CI prepares the test database with:

    bin/rails db:create db:schema:load

Loading the schema avoids running demo seeds during normal test-database setup. Seed behavior is covered separately by `spec/seeds_spec.rb`.

### Tests and coverage

CI records three coverage results:

| Result | Coverage directory |
| --- | --- |
| RSpec alone | `coverage/rspec` |
| Cucumber alone | `coverage/cucumber` |
| Both suites combined | `coverage/total` |

Both suites run again into the combined directory. CI reads each result and fails if any is below 90% line coverage.

RSpec includes the browser-based axe accessibility test. CI installs Chrome for that test.

RuboCop runs as the final style check.

### Merge and deployment rules

The active `Protect main` ruleset requires:

- A pull request.
- At least one approving review.
- A passing `test` status check.
- No force pushes or branch deletion.

The ruleset does not require a branch to be up to date with `main` before merging.

The documented Heroku setup waits for CI to pass before automatically deploying `main`. The release command runs database migrations.

## Consequences

- Features need appropriate RSpec and Cucumber coverage because each suite has its own coverage requirement.
- The suites run twice to measure individual and combined coverage.
- Normal test runs start without demo data introduced by database setup.
- Two branches can pass independently but fail when combined. Teammates should merge current `main` and test the combined changes, especially when files overlap.
- Local test results and GitHub CI results must be reported accurately when the environments behave differently.

## References

- [CI workflow](../../.github/workflows/ci.yml)
- [Seed tests](../../spec/seeds_spec.rb)
- [Accessibility system test](../../spec/system/accessibility_spec.rb)
- [Heroku process commands](../../Procfile)
- [Main protection rules](https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed/rules/26235710)
- [Coverage failure postmortem](../postmortems/2026-10-30-main-failed-cucumber-coverage.md)
- [CI runner change postmortem](../postmortems/2026-11-08-ci-failed-after-runner-image-change.md)
