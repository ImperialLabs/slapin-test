FROM slapi/ruby:latest

MAINTAINER SLAPI Devs

# Use labels to create help commands
# arg="description"
LABEL "parse_all"="parse all data from slack"

RUN mkdir -p /parse && chmod 777 /parse
WORKDIR /parse

# Copy pager cli to container
COPY . ./

# Install dependencies
RUN gem install json

ENTRYPOINT ["ruby", "/parse/parse.rb"]
