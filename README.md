# Port Call Board

[![CI](https://github.com/abakymukmeta/maersk_mvp/actions/workflows/ci.yml/badge.svg)](https://github.com/abakymukmeta/maersk_mvp/actions/workflows/ci.yml)

Rails 8 + Hotwire + Tailwind. Ruby 3.4.5 via mise. PostgreSQL 16.

## Requirements
- Ruby 3.4.5 (mise)
- Supabase account and project
- Node 20+, yarn|npm

## Quick Start
```bash
mise use -p ruby@3.4.5
# Copy .env.example to .env and configure your Supabase credentials
cp .env.example .env
# Edit .env with your Supabase database URL
bin/setup
bin/dev

Health: http://localhost:3000/healthz
```

## Supabase Setup
1. Create a new project at [supabase.com](https://supabase.com)
2. Go to Settings > Database to get your connection string
3. Copy `.env.example` to `.env` and update with your Supabase credentials:
   ```bash
   cp .env.example .env
   ```
4. Update the DATABASE_URL in `.env` with your Supabase connection string

## Development

### Setup
```bash
bin/setup
```

### Run development server
```bash
bin/dev
```

### Run tests
```bash
bundle exec rspec
```

### Database
```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## CI / Quality Gates

This project uses strict CI quality gates to ensure code quality and security:

### Local Quality Checks
```bash
# Lint code
bundle exec rubocop

# Run tests
bundle exec rspec

# Security audit
bundle exec brakeman -q -w2
bundle exec bundle audit check --update

# Build assets
RAILS_ENV=production bin/rails assets:precompile
```

### CI Pipeline
- **Lint**: RuboCop code style checks
- **Test**: RSpec tests with PostgreSQL service
- **Security**: Brakeman + Bundler-audit vulnerability scans
- **Assets**: Production asset compilation (esbuild + Tailwind)

All checks must pass before merging PRs.
