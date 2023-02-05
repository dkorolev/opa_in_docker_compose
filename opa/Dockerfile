FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y curl

RUN curl -L -o opa https://openpolicyagent.org/downloads/v0.48.0/opa_linux_amd64_static
RUN chmod +x opa
RUN mv opa /usr/local/bin

HEALTHCHECK --interval=1s --timeout=1s --retries=10 --start-period=3s CMD [ -f .opa_up ]

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
