FROM ubuntu:latest

LABEL mantainer="Lucas Valente"
LABEL repo="https://github.com/serramatutu/dotfiles"
LABEL description="Test environment for serramatutu's dotfiles"

RUN apt-get update
RUN apt-get -y install python3.7
# Speeds up testing even though the installer will try to fetch pip
RUN apt-get -y install python3-pip
RUN apt-get -y install python3-venv

ADD . /dotfiles
WORKDIR /dotfiles

ENV DOTFILES_ENV="TEST"

CMD ["sh", "installer/bootstrap"]