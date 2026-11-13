# Postmortem: CI failed on every branch after the GitHub runner image changed (Nov 8, 2026)
 
## Impact
 
CI failed at the "Set up Ruby" step on every branch and pull request, before any tests ran. No PR could pass CI, so nothing could be merged with a green check, and Heroku (which waits for CI to pass) couldn't deploy. Open PRs looked broken even though their own changes were fine. It happened in the middle of Sprint 2, while several stories were in review.
 
## Timeline
 
- **Before Nov 8:** GitHub moved the `ubuntu-latest` runner label from Ubuntu 24.04 to Ubuntu 26.04. Our workflow used `runs-on: ubuntu-latest`, so CI switched images without any change on our side.
- **Nov 8:** While working on #74 (#35 Report a user), Jason found CI failing at "Set up Ruby" on every branch, not just his. `ruby/setup-ruby` had no prebuilt Ruby 3.4.5 for Ubuntu 26.04.
- **Nov 8:** Jason pinned the workflow to `runs-on: ubuntu-24.04` in #74 and removed an unused `ruby-version-file` input. CI passed again on #74.
- **Nov 8:** #74 was approved and merged; `main` passed CI again.
- **Nov 9:** Jason told the team CI was fixed on `main` and how to merge `main` into their branches to pick up the fix.
## Root cause
 
The workflow used the floating `ubuntu-latest` label. When GitHub pointed that label at a newer Ubuntu release, `ruby/setup-ruby` couldn't install our pinned Ruby version (3.4.5, from `.ruby-version`), because no prebuilt binary existed for the new image. Nothing in our code changed; the build environment changed underneath us.
 
## Resolution
 
Pinned the runner to `ubuntu-24.04` in `.github/workflows/ci.yml` (#74), which has a prebuilt Ruby 3.4.5. Branches picked up the fix by merging `main`.
 
## Follow-up actions
 
- Created a Sprint 4 chore (#77) to upgrade Ruby to 3.4.12 and then unpin the runner, once CI confirms `ruby/setup-ruby` supports it on the newer image.
- When CI fails on a step before the tests run (setup, install), check whether `main` and other branches fail the same way before debugging your own change, and post it in Discord so others don't chase the same failure.
- Keep the runner pinned to a specific Ubuntu version rather than `ubuntu-latest`, and upgrade it on purpose (with Dependabot or a planned chore) so image changes don't surprise us mid-sprint.