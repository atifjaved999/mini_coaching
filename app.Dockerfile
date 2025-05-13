# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.3
FROM ruby:$RUBY_VERSION-slim as base

WORKDIR /rails

ENV RAILS_ENV="development" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# --- Build Stage ---
FROM base as build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

# Match the lockfile Bundler version
COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.6.8 && \
    bundle config set force_ruby_platform true && \
    bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY . .

# Precompile Bootsnap cache (optional)
RUN bundle exec bootsnap precompile app/ lib/ || echo "Bootsnap precompile failed, skipping..."

# --- Final Stage ---
FROM base

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]