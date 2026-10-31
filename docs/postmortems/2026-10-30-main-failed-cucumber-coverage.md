# Postmortem: main failed the Cucumber-only coverage check (Oct 30, 2026)

## Impact

For about an hour (roughly 6:55 PM to 7:45 PM), CI on `main` failed. Heroku waits for CI to pass, so nothing deployed during that time. Open pull requests (e.g. #53) showed a failing coverage check even though their own changes were fine, which confused their authors.

## Timeline

- **6:34 PM:** #47 (like/pass and matches) merged. CI at the time only checked total coverage, which passed.
- **6:54 PM:** #49 merged, adding separate RSpec and Cucumber coverage checks. Its own CI run had passed before #47 was on `main`.
- **6:54–6:55 PM:** The next CI runs on `main` failed: Cucumber-only coverage was 89.8%.
- **7:02 PM:** Colin reported his PR failing at 89.8% while his local run showed 96%.
- **7:11 PM:** Cause identified and explained to the team.
- **7:45 PM:** #55 (Cucumber scenarios for the Matches page, by Zachary) merged; `main` passed again.

## Root cause

The Matches page from #47 had no Cucumber scenarios, so its code was only covered by RSpec. That was invisible until #49 started checking Cucumber on its own. Each PR passed against the version of `main` it was tested on; together they failed. The 96% local figure was RSpec and Cucumber merged into one report, not Cucumber alone.

## Resolution

Added `features/matches.feature` (see a match, no matches, blocked match hidden, no-profile redirect), bringing Cucumber-only coverage back above 90%.

## Follow-up actions

- The Definition of Done now states the 90% threshold applies to Cucumber alone, RSpec alone, and the total.
- The README documents how to check Cucumber-only coverage locally: `rm -rf coverage && COVERAGE_DIR=coverage/cucumber bundle exec cucumber`.
- Considered requiring branches to be up to date before merging (would have caught this); not adopted for now, since it adds an "Update branch" step to every PR. Revisit if it happens again.