# wingmAIn

A dating web app where you never browse alone: every user gets an AI companion that reacts to profiles, chats with them about each person, and helps them start conversations.

- **Live app:** https://wingmain-427a5124258b.herokuapp.com
- **Product Backlog:** GitHub Projects board linked to this repository
- **Team:** Colin Bakker, Jason Atkins, Christopher Parker, Zachary Williams, Can Ercan, Sugam Mishra

---

# Technical Documentation

## Tech stack

- Ruby 3.4.5, Rails 8.1
- PostgreSQL 16
- Devise (authentication)
- Anthropic API (AI companion), wrapped in `CompanionService`
- RSpec + FactoryBot + Shoulda Matchers (unit tests), Cucumber + Capybara (acceptance tests), SimpleCov (coverage), RuboCop (style)
- Hosted on Heroku with Heroku Postgres; CI on GitHub Actions

Every page is server-rendered with plain HTML forms, so the app works with JavaScript disabled.

## From zero to running locally

### 1. Install prerequisites (macOS shown)

```bash
brew install rbenv ruby-build postgresql@16
rbenv install 3.4.5
brew services start postgresql@16
```

### 2. Clone and set up

```bash
git clone https://github.com/tamu-edu-students/CSCE606-700-Fall2026-GroupRed.git
cd CSCE606-700-Fall2026-GroupRed
bundle install
bin/rails db:prepare   # creates and migrates the development and test databases
bin/rails db:seed      # demo data: an admin plus 30 profiles
bin/rails server
```

Open http://localhost:3000.

**Demo logins** (local and production): any seeded profile, e.g. `peter.parker@wingmain.test`, password `password123`.
The admin account is `admin@wingmain.test`; locally its password is `password123`.

**AI companion locally:** set `ANTHROPIC_API_KEY` to get real AI replies. Without it, the companion shows a friendly fallback message and everything else works.

### 3. Run the tests

```bash
bundle exec rspec       # unit tests
bundle exec cucumber    # acceptance tests
bin/rubocop             # style
```

CI runs each suite separately and fails if RSpec, Cucumber, or the combined total is under 90% line coverage. To check locally:

```bash
rm -rf coverage
COVERAGE_DIR=coverage/rspec bundle exec rspec
COVERAGE_DIR=coverage/cucumber bundle exec cucumber
```

Each run prints its coverage; the HTML report is in that folder's `index.html`.

After every `git pull`, run `bundle install` and `bin/rails db:migrate` to pick up teammates' new gems and tables.

## From zero to deployed (fresh fork)

1. **Create the Heroku app and database**
   ```bash
   heroku create your-app-name
   heroku addons:create heroku-postgresql:essential-0 -a your-app-name
   ```
2. **Credentials.** A fresh fork can't decrypt our `config/credentials.yml.enc`. Generate your own:
   ```bash
   rm config/credentials.yml.enc
   EDITOR=true bin/rails credentials:edit   # creates config/master.key and new credentials
   heroku config:set RAILS_MASTER_KEY=$(cat config/master.key) -a your-app-name
   ```
   Commit the new `credentials.yml.enc`. Never commit `config/master.key`.
3. **Other config vars**
   ```bash
   heroku config:set ADMIN_PASSWORD='choose-a-strong-password' -a your-app-name
   heroku config:set ANTHROPIC_API_KEY='your-key' -a your-app-name   # optional
   ```
4. **Automatic deploys:** Heroku dashboard → your app → **Deploy** → connect to GitHub → choose the repo → enable **Automatic deploys** from `main` with **Wait for CI to pass** checked. Click **Deploy Branch** once.
5. **Migrations** run automatically on each release (`release` line in the `Procfile`).
6. **Seed demo data**
   ```bash
   heroku run bin/rails db:seed -a your-app-name
   ```

### Our deployment

- Every merge to `main` deploys automatically once CI passes.
- `main` is protected: changes go through a pull request with one approval and passing CI.
- Secrets live only in Heroku config vars: `RAILS_MASTER_KEY`, `DATABASE_URL` (set by Heroku Postgres), `ADMIN_PASSWORD`, `ANTHROPIC_API_KEY`.
- Logs: `heroku logs --tail -a wingmain`

## Architecture

### System diagram

```mermaid
flowchart TB
  Browser["User's browser<br/>(HTML forms, no JS required)"] -->|HTTPS| Rails["Rails 8.1 app<br/>(Puma on Heroku)"]
  Rails --> DB[("Heroku Postgres")]
  Rails -->|CompanionService| AI["Anthropic API"]
  Dev["Developer"] -->|pull request| GitHub["GitHub"]
  GitHub --> CI["GitHub Actions<br/>RSpec · Cucumber · RuboCop · coverage"]
  CI -->|passes on main| Heroku["Heroku auto-deploy"]
  Heroku --> Rails
```

### Database diagram (current schema)

```mermaid
erDiagram
  USERS ||--o| PROFILES : "has one"
  USERS ||--|| COMPANIONS : "has one"
  USERS ||--o{ BLOCKS : "blocks (blocker)"
  USERS ||--o{ BLOCKS : "is blocked (blocked)"

  USERS {
    bigint id PK
    string email "unique"
    string encrypted_password
    date date_of_birth
    string role "user or admin"
    datetime suspended_at
  }
  PROFILES {
    bigint id PK
    bigint user_id FK "unique"
    string display_name
    text bio
    string gender
    string interested_in
    integer age_min
    integer age_max
  }
  COMPANIONS {
    bigint id PK
    bigint user_id FK "unique"
    string name
    string personality
    text memory_summary
    text greeting
  }
  BLOCKS {
    bigint id PK
    bigint blocker_id FK
    bigint blocked_id FK
  }
```

### Key classes

| Class | Responsibility |
| --- | --- |
| `User` | Devise account; owns a profile and companion; block helpers (`blocked_with?`, `User.not_blocked_with`) |
| `Profile` | Dating profile and preferences, with validations (name ≤ 40, bio ≤ 500, ages ≥ 18) |
| `Companion` | The user's AI companion; created automatically at sign-up |
| `CompanionService` | Only place that calls the AI API; 10-second timeout and a fallback message on errors |
| `Block` | One user blocking another; blocks apply both ways |

---

# User Guide

## Getting started

1. Go to the home page and click **Sign Up**.
2. Enter your email, date of birth, and a password (6+ characters).
3. Create your profile: display name, bio, gender, who you're interested in, and the age range you're looking for.

## Your profile

- **View it** at **My profile** (`/profile`).
- **Edit it** with **Edit profile**. If something is invalid (e.g. an age under 18), the form explains what to fix.

## Your AI companion

Every account comes with a companion named **Wingman**. Visit `/companion` to meet it. If the AI service is unavailable, you'll see a short "taking a break" message and the rest of the app keeps working.

## Viewing and blocking people

- Each person has a profile page at `/people/<id>`.
- Click **Block <their name>** on their profile and confirm. Blocking works both ways: neither of you can see the other's profile.
- Manage blocks at **My profile → Blocked people**, where you can **Unblock** anyone.

## Coming soon (in progress)

Browsing and liking/passing on profiles, matches, messaging, and the companion reacting to profiles are being built in the current sprint.
