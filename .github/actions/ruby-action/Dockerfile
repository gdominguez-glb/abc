FROM ubuntu:bionic
RUN apt-get update && \
    apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev \
                       git curl gnupg2 libpq-dev default-libmysqlclient-dev nodejs graphviz ssh && \
    rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/rbenv/rbenv.git /usr/local/rbenv && \
    ln -s /usr/local/rbenv/bin/rbenv /usr/local/bin/rbenv
RUN git clone  https://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build && \
    /usr/local/rbenv/plugins/ruby-build/install.sh && \ 
    /usr/local/rbenv/bin/rbenv install 2.6.3 && \
    /usr/local/rbenv/bin/rbenv global 2.6.3 && \
    /root/.rbenv/shims/gem install bundler -v 1.16.1 && \
    /root/.rbenv/shims/gem install capistrano -v 3.14.1

ENV TERM dumb
ENV PATH="/root/.rbenv/versions/2.6.3/bin/:${PATH}"
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["tail", "-f", "/dev/null"]
#ENTRYPOINT ["/entrypoint.sh"]
