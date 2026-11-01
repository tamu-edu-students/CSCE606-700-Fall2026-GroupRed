# Debug Pointers

Problems we've hit and what fixed them.

| Symptom | Cause | Fix |
| --- | --- | --- |
| `Could not find <gem> in locally installed gems` after `git pull` | A teammate added or updated a gem | `bundle install` |
| `ActiveRecord::PendingMigrationError` after `git pull` | A teammate added a table | `bin/rails db:migrate` |
| `Gemfile.lock` shows as modified after `bundle install` on a Mac | Your platform wasn't in the lockfile | Fixed: `x86_64-darwin` is now in `Gemfile.lock`. If it happens on another platform: `bundle lock --add-platform <platform>` and commit it |
| Local coverage says 96% but CI fails Cucumber coverage | Running both suites into the same `coverage/` folder merges them | Check one suite alone: `rm -rf coverage && COVERAGE_DIR=coverage/cucumber bundle exec cucumber` |
| `[SimpleCov]: Excluded 1 result(s) older than merge_timeout` | An old result from the other suite is over 10 minutes old | Harmless; `rm -rf coverage` before running both suites |
| Merge conflict in `Gemfile.lock` | Two branches changed gems | `git merge origin/main`, keep both changes in `Gemfile`, run `bundle install`, commit the regenerated lockfile |
| Production won't boot after a deploy | `RAILS_MASTER_KEY` missing on Heroku | `heroku config:set RAILS_MASTER_KEY=$(cat config/master.key) -a wingmain` (whoever has the key) |
| Companion always shows "taking a quick break" | No `ANTHROPIC_API_KEY` set, or the AI timed out | Set the key locally or on Heroku; check `heroku logs --tail -a wingmain` for `CompanionService` errors |
| A request spec passes but doesn't test what it says | Params sent without the `user:` (or model) wrapper, so the app saw empty input | Wrap params, e.g. `params: { user: {...} }`, and assert the specific error message |