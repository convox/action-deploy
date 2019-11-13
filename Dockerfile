FROM ubuntu:18.04

LABEL version="1.0.0"
LABEL repository="https://github.com/convox/action-deploy"
LABEL homepage="https://convox.com/convox"
LABEL maintainer="Convox <support@convox.com>"

LABEL "com.github.actions.name"="Convox Deploy"
LABEL "com.github.actions.description"="Build and Deploy an app to Convox in one step"
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="blue"

RUN apt-get -qq update && apt-get -qq -y install curl

RUN curl -L https://convox.com/cli/linux/convox -o /tmp/convox \
    && mv /tmp/convox /usr/local/bin/convox \
    && chmod 755 /usr/local/bin/convox

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]