FROM ubuntu:20.04

LABEL Maintainer "Apoorv Vyavahare <apoorvvyavahare@pm.me>"

ARG DEBIAN_FRONTEND=noninteractive

#VNC Server Password
ENV VNC_PASS="samplepass" \
#VNC Server Title(w/o spaces)
    VNC_TITLE="Vubuntu_Desktop" \
#VNC Resolution(720p is preferable)
    VNC_RESOLUTION="1280x720" \
#VNC Shared Mode (0=off, 1=on)
    VNC_SHARED=0 \
#Local Display Server Port
    DISPLAY=:0 \
#NoVNC Port
    NOVNC_PORT=$PORT \
#Locale
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ="Etc/UTC"

COPY . /app/.vubuntu

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get --no-install-recommends install -y \
#Basic Packages
    tzdata software-properties-common apt-transport-https wget zip unzip htop git curl vim nano zip sudo net-tools x11-utils eterm iputils-ping build-essential xvfb x11vnc supervisor \
#GUI Utilities
    gnome-terminal \
    gnome-calculator \ 
    #gnome-system-monitor \
    #pcmanfm \
    #terminator \
    firefox \
#Python
    python3 python3-pip python-is-python3 \
#Java
    #default-jre default-jdk \
#Text Editors
    vim-gtk3 \
    #mousepad \
    #pluma \
#NodeJS
    nodejs npm \
#Other Languages
    #golang \
    #perl \
    #ruby \
    #lua5.3 \
    #scala \
    #mono-complete \
    #r-base \
    #clojure \
    #php \
#Extras
    #libreoffice \
    gnupg \
    dirmngr \
    gdebi-core \
    nginx \
    openssh-client \
    openssh-server \
    ffmpeg && \
#Fluxbox & noVNC
    apt-get install --no-install-recommends -y /app/.vubuntu/assets/packages/fluxbox.deb /app/.vubuntu/assets/packages/novnc.deb && \
    cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html && \
    openssl req -new -newkey rsa:4096 -days 36500 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Private/O=Dis/CN=www.google.com" -keyout /etc/ssl/novnc.key  -out /etc/ssl/novnc.cert && \
#Websockify
    npm i websockify && \
#MATE Desktop (remove "/app/.vubuntu/assets/packages/fluxbox.deb" from line 66 before uncommenting)
    #apt-get install -y \
    #ubuntu-mate-core \
    #ubuntu-mate-desktop && \
#XFCE Desktop (remove "/app/.vubuntu/assets/packages/fluxbox.deb" from line 66 before uncommenting)
    #apt-get install -y \
    #xubuntu-desktop && \
#TimeZone
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
#VS Code - source
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg && \
    install -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list && \
#PowerShell - source
    wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -P /tmp && \
#Installation
    apt-get update && \
    apt-get install --no-install-recommends code /tmp/packages-microsoft-prod.deb -y && \
    apt-get update && \
    apt-get install --no-install-recommends -y powershell && \
#Wipe Temp Files
    rm -rf /var/lib/apt/lists/* && \ 
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /tmp/*

ENTRYPOINT ["supervisord", "-l", "/app/.vubuntu/assets/logs/supervisord.log", "-c"]

CMD ["/app/.vubuntu/assets/configs/supervisordconf"]
