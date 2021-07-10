
FROM ruby:3.0.0-alpine

WORKDIR /web

ENV ALPINE_MIRROR="http://dl-cdn.alpinelinux.org/alpine"
ENV RAILS_ENV="staging"
ENV RAILS_SERVE_STATIC_FILES="true"

COPY Gemfile Gemfile.lock /web/
COPY package.json yarn.lock /web/

RUN echo "${ALPINE_MIRROR}/v3.13/main" >> /etc/apk/repositories
RUN apk update && apk upgrade
RUN apk add --no-cache -t .build-dependencies build-base libxml2-dev libxslt-dev \
  && apk add --no-cache bash file imagemagick libpq sudo libxml2 libxslt nodejs mysql-client mysql-dev tini tzdata yarn linux-headers
RUN apk add --no-cache bash git openssh
RUN gem install bundler:2.1.4 \
  && bundle config without 'development test' \
  && bundle config deployment true \
  && bundle install -j$(getconf _NPROCESSORS_ONLN)
RUN yarn install
RUN apk del --purge .build-dependencies

COPY . /web

RUN bundle exec bin/rails assets:precompile SECRET_KEY_BASE="tmp" \
  && yarn cache clean \
  && rm -rf node_modules tmp/cache terraform

ENTRYPOINT ["/sbin/tini", "--"]
EXPOSE 80
