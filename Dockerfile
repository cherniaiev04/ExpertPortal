FROM ruby:3.3.5-alpine3.20

RUN apk update && apk add \
    bash \
    nodejs \
    make \
    gcc \
    g++ \
    libc-dev \
    micro \
    git \
    libc6-compat \
    # Chrome (for UI Testing)
    chromium \
    chromium-chromedriver \
    nss \
    freetype \
    harfbuzz \
    ttf-freefont \
    libxshmfence \
    udev \
    libpq-dev \
    # Add image, PDF dependencies:
    vips \
    poppler-utils

WORKDIR /expertgrid

COPY Gemfile /expertgrid/Gemfile
COPY Gemfile.lock /expertgrid/Gemfile.lock
RUN bundle install

RUN git config --global --add safe.directory /expertgrid

RUN rails db:migrate

EXPOSE 3000

CMD ["/bin/bash"]
