FROM ubuntu:12.04
MAINTAINER Matthew Francis-Landau <matthew@matthewfl.com>

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y build-essential
RUN apt-get install -y bc

COPY Makefile /
