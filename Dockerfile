FROM mcr.microsoft.com/devcontainers/base:bookworm

ENV DEBIAN_FRONTEND noninteractive
COPY *.sh /tmp/scripts/
RUN bash /tmp/scripts/build.sh
