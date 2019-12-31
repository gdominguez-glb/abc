FROM ruby:2.2.0

RUN apt update && \
  apt install -y --no-install-recommends \
  git \
  curl \
  gnupg2 \
  libpq-dev \
  libmysqlclient-dev \
  nodejs \
  graphviz \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ./home/

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs

COPY . .
