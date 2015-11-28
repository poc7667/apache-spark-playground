FROM smungee/pyspark-docker
USER root
#=====

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ trusty main multiverse restricted universe" >> /etc/apt/sources.list && \
    echo "deb-src http://free.nchc.org.tw/ubuntu/ precise main restricted" >> /etc/apt/sources.list 

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends --yes libav-tools zip curl \
    build-essential \
    tree \
    zsh \
    sudo \
    openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev \ 
    libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev \
    autoconf libc6-dev ncurses-dev automake libtool bison \
    x11vnc \ 
    xvfb \ 
    wget \ 
    psmisc \
    && rm -rf /var/lib/apt/lists/*
  
#=================
# Locale settings
#=================
ENV LANGUAGE zh_TW.UTF-8 
#en_US.UTF-8
ENV LANG  zh_TW.UTF-8
#en_US.UTF-8
RUN locale-gen en_US.UTF-8 \
  zh_TW zh_TW.UTF-8 zh_CN.UTF-8 en_US.UTF-8 \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get update -qqy \
  && apt-get -qqy --no-install-recommends install \
    language-pack-en \
  && rm -rf /var/lib/apt/lists/*

#========================
# Install Zsh
#========================
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \
    && chsh -s /bin/zsh

RUN sed -i -E "s/^plugins=\((.*)\)$/plugins=(\1 git git-flow  )/" ~/.zshrc  
RUN echo "export TERM=vt100" >> /etc/zsh/zshrc

# bindkey to make HOME/END works on zsh shell
# set term=xtern make HOME/END works in vim
RUN echo "alias ls='ls --color=auto'" >> /etc/zsh/zshrc && \
    echo "alias ll='ls -halF'" >> /etc/zsh/zshrc && \
    echo "bindkey -v" >> /etc/zsh/zshrc && \
    echo "bindkey '\eOH'  beginning-of-line" >> /etc/zsh/zshrc && \
    echo "bindkey '\eOF'  end-of-line" >> /etc/zsh/zshrc && \
    echo "alias ls='ls --color=auto'" >> /etc/profile &&\
    echo "set term=xterm" >> ~/.vimrc 

RUN useradd -m -d /home/deploy -s /bin/zsh deploy  \
    && echo "deploy:deploy" | chpasswd \
    && echo "deploy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER deploy
ENV LANGUAGE zh_TW.UTF-8 
ENV LANG  zh_TW.UTF-8

CMD ["/etc/bootstrap.sh"]