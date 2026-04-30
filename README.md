# Easy Vote

Rails 8 app for feature voting, built in small learning-focused increments with:
Tailwind, Turbo, Stimulus, PostgreSQL, Solid Queue, Solid Cable, Docker, and RSpec.

## Stack

- Ruby 4.0.2
- Rails 8.1
- PostgreSQL
- Solid Queue + Solid Cable
- Turbo + Stimulus + Tailwind
- RSpec

## Local Setup (without Docker)

```bash
bundle install
bin/rails db:prepare
bin/dev
```

## Local Setup (with Docker services)

Start PostgreSQL:

```bash
docker compose up -d db
```

Run app:

```bash
bundle install
bin/rails db:prepare
bin/dev
```

## Run tests

```bash
bundle exec rspec
```
