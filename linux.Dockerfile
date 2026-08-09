FROM lacledeslan/steamcmd:linux AS downloader

ARG CONTENT_SERVER=content.lacledeslan.net

RUN echo "Downloading cs2d base" && \
    curl -sSL "http://${CONTENT_SERVER}/fastDownloads/_installers/cs2d_1017_linux.zip" -o /tmp/cs2d_linux.zip && \
echo "Validating download against known hash" && \
    echo "a248938a2a987d8bcc772e809d4bf9e764279566907769d3af1220743e26d279  /tmp/cs2d_linux.zip" | sha256sum -c - && \
echo "Extracting CS2D base files" && \
    mkdir --parents /output && \
    unzip /tmp/cs2d_linux.zip -d /output;

RUN echo "Downloading cs2d server files" && \
    curl -sSL "http://${CONTENT_SERVER}/fastDownloads/_installers/cs2d_1.0.1.7_dedicated_linux.zip" -o /tmp/cs2d_dedicated_linux.zip && \
echo "Validating download against known hash" && \
    echo "4b6573d9ec88a0f62ab3dac08c68ea89aac16902fe324ee6296607dbed2176f3  /tmp/cs2d_dedicated_linux.zip" | sha256sum -c - && \
echo "Extracting CS2D server files" && \
    mkdir --parents /output && \
    unzip /tmp/cs2d_dedicated_linux.zip -d /output;

COPY ./dist/linux /output


#---------------------------------
FROM debian:trixie-slim

ARG BUILD_DATE=unspecified \
    BUILD_NODE=unspecified \
    GIT_REVISION=unspecified

HEALTHCHECK NONE

LABEL architecture="i386" \
      com.lacledeslan.build-node="$BUILD_NODE" \
      maintainer="Laclede's LAN <contact@lacledeslan.com>" \
      org.opencontainers.image.created="$BUILD_DATE" \
      org.opencontainers.image.description="Counter-Strike 2D Dedicated Server" \
      org.opencontainers.image.revision="$GIT_REVISION" \
      org.opencontainers.image.source="https://github.com/LacledesLAN/gamesvr-cs2d" \
      org.opencontainers.image.vendor="Laclede's LAN"

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y \
        ca-certificates locales locales-all libsdl1.2debian whiptail libc6:i386 libstdc++6:i386 tmux \
        --no-install-recommends --no-install-suggests --no-upgrade && \
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
    useradd --home /app --gid root --system CS2D && \
    mkdir --parents /app /dist/sys/logs && \
    chown CS2D:root -R /app;

COPY --chown=CS2D:root --from=downloader /output /app

RUN chmod +x /app/cs2d_dedicated && \
    chmod +x /app/ll-tests/gamesvr-cs2d.sh;

USER CS2D

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
