FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

# Use labels to create help commands
# arg="description"
LABEL "parse"="parse all data from slack"

RUN mkdir -p /parse && chmod 777 /parse
WORKDIR /parse

# Copy app to container
COPY . ./

ENTRYPOINT ["ruby", "/parse/parse.rb"]
