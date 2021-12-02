FROM ubuntu:20.04
MAINTAINER cht.andy@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Taipei
RUN set -eux \
  && mv /bin/sh /bin/sh.old && ln -s /bin/bash /bin/sh \
  && apt-get update && apt-get install --assume-yes locales tzdata bash-completion supervisor curl vim \
  && locale-gen zh_TW.UTF-8 && update-locale LANG=zh_TW.UTF-8 \
  && rm -rf /var/lib/apt/lists/* && apt-get clean \
  && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN { \
     echo "[supervisord]"; \
     echo "nodaemon=true"; \
     echo "user=root"; \
     echo "logfile=/dev/null"; \
     echo "logfile_maxbytes=0"; \
     echo "pidfile=/tmp/supervisord.pid"; \
     } > /etc/supervisor/conf.d/supervisord.conf \
  && { \
     echo "set paste"; \
     echo "syntax on"; \ 
     echo "colorscheme torte"; \
     echo "set t_Co=256"; \
     echo "set nohlsearch"; \
     echo "set fileencodings=ucs-bom,utf-8,big5,gb18030,euc-jp,euc-kr,latin1"; \
     echo "set fileencoding=utf-8"; \
     echo "set encoding=utf-8"; \
     echo "set nohlsearch"; \
     } >> /etc/vim/vimrc

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/bin/kubectl

ENTRYPOINT ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
