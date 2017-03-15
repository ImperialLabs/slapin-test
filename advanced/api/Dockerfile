FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

ENV APP_HOME /api

RUN mkdir -p $APP_HOME &&\
    mkdir -p $APP_HOME/log

RUN mkdir -p $APP_HOME && chmod 777 /api

WORKDIR /api

COPY supervisord.conf /etc/supervisor.d/supervisord.conf

# Copy app into container
COPY . ./

RUN apk update && apk add \
    supervisor &&\
    if [ -f Gemfile.lock ]; then rm -f Gemfile.lock; fi &&\
    gem install json \
    sinatra \
    httparty &&\
    rm -rf /var/cache/apk/* &&\
    rm -rf /tmp/*

EXPOSE 8100

CMD ["supervisord", "-c", "/etc/supervisor.d/supervisord.conf", "-n"]
