FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

# Use labels to create help commands
# arg="description"
LABEL "get"="get a key value from redis, `@bot api get key`"
LABEL "save"="save data into redis `@bot api save key value`"

RUN mkdir -p /parse && chmod 777 /api
WORKDIR /api

# Copy app into container
COPY . ./

# Install dependencies
RUN gem install json
RUN gem install sinatra
RUN gem install httparty

ENTRYPOINT ["ruby", "/api/api.rb"]
