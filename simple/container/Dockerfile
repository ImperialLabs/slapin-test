FROM slapi/base:latest

MAINTAINER SLAPI Devs

# Use labels to create help commands
# arg="description"
LABEL "description"="Hello World Test Plugin"
LABEL "world"="says hello world"

RUN mkdir -p /hello && chmod 777 /hello
WORKDIR /hello

# Copy pager cli to container
COPY . ./

ENTRYPOINT ["/hello/hello.sh"]
