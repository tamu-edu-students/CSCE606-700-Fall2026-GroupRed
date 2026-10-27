# Technical Documentation

## Prepare the local database
bin/rails db:prepare

## Run all Cucumber scenarios
bundle exec cucumber

## Run a specific feature
bundle exec cucumber features/smoke.feature

## Run the application
bin/rails server

* Detailed instructions for taking the code from zero (fresh fork/clone) to deployed

* Architectural schemas, e.g. system diagram, class diagram, database diagram

## Deployment

The app is deployed on Heroku: https://wingmain-427a5124258b.herokuapp.com

- Every merge to `main` deploys automatically once CI passes (Heroku GitHub integration, "Wait for CI to pass" enabled).
- Database migrations run automatically on each release (`release` command in the `Procfile`).
- Secrets are stored as Heroku config vars, never in the repo:
  - `RAILS_MASTER_KEY` — decrypts `config/credentials.yml.enc`
  - `DATABASE_URL` — set by the Heroku Postgres add-on
  - `ANTHROPIC_API_KEY` — AI companion

To deploy manually: Heroku dashboard → **wingmain** → **Deploy** → **Manual deploy** → **Deploy Branch**.

To check logs: `heroku logs --tail -a wingmain`

# User Guide

* A comprehensive guide on how to use your application, library or software for end-users.

