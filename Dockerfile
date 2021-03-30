FROM ruby:2.6.3

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  git \
  curl \
  gnupg2 \
  libpq-dev \
  default-libmysqlclient-dev \
  nodejs \
  graphviz \
  shared-mime-info \
  && rm -rf /var/lib/apt/lists/*

WORKDIR ./home/

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .
