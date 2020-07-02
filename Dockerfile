FROM ruby:2.4.2

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
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

RUN bundle install

COPY . .
