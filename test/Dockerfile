FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl jq

COPY test.sh /
ENTRYPOINT ["/test.sh"]
