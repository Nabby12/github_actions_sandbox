FROM alpine:3.10
# FROM debian:9.5-slim  <--  #!/bin/bash起動可能

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
