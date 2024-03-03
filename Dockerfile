# Goal: get to something like this: https://dev.to/ndrean/make-slim-rails-images-2hi3
ARG RUBY_VERSION
# 3.3-slim installs debian bookworm
FROM ruby:$RUBY_VERSION-slim

RUN apt update && apt install -y \
    build-essential

RUN addgroup ruby

ARG APP_USER
RUN adduser \
    --ingroup ruby \
    --disabled-login \
    --home /user/${APP_USER} \
    ruby

USER ruby

WORKDIR /app

COPY --chown=ruby:ruby Gemfile ./

RUN bundle install

# At this point, I can bash into the container and run "rails new" or whatever

# To update Gemfile.lock using Docker (and not requiring ruby locally), do
# `docker compose run --build --rm -v "$PWD":/app -w /app app bundle install`
