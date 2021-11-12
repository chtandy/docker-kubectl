FROM ubuntu:20.04
MAINTAINER cht.andy@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
ARG UTCTimeZone=Asia/Taipei
RUN set -eux \
  && mv /bin/sh /bin/sh.old && ln -s /bin/bash /bin/sh \
  && apt-get update \
  && apt-get install --assume-yes locales supervisor bash-completion curl \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && ln -snf /usr/share/zoneinfo/${UTCTimeZone} /etc/localtime && echo ${UTCTimeZone} > /etc/timezone \
  && { \
     echo "[supervisord]"; \
     echo "nodaemon=true"; \
     echo "logfile=/dev/null"; \
     echo "logfile_maxbytes=0"; \
     echo "pidfile=/tmp/supervisord.pid"; \
     } > /etc/supervisor/conf.d/supervisord.conf \
  && curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/bin/kubectl 
ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
