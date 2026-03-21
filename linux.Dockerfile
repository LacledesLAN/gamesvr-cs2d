# escape=`
FROM lacledeslan/steamcmd:linux AS downloader

ARG contentServer=content.lacledeslan.net

RUN echo "Downloading cs2d base" &&`
    curl -sSL "http://${contentServer}/fastDownloads/_installers/cs2d_1016_linux.zip" -o /tmp/cs2d_1016_linux.zip &&`
echo "Validating download against known hash" &&`
    echo "E2DE8000B639AADDD373BF47568A4B55DAE59D3E246E7A109FB61394A5E45381  /tmp/cs2d_1016_linux.zip" | sha256sum -c - &&`
echo "Extracting CS2D base files" &&`
    mkdir --parents /output &&`
    unzip /tmp/cs2d_1016_linux.zip -d /output;

RUN echo "Downloading cs2d server files" &&`
    curl -sSL "http://${contentServer}/fastDownloads/_installers/cs2d_dedicated_linux_1016.zip" -o /tmp/cs2d_dedicated_linux.zip &&`
echo "Validating download against known hash" &&`
    echo "D3ABF492D1ABE1B5BB534422CA5E2C402AB76227AEBDBC197A2BD0CE591146F1  /tmp/cs2d_dedicated_linux.zip" | sha256sum -c - &&`
echo "Extracting CS2D server files" &&`
    mkdir --parents /output &&`
    unzip /tmp/cs2d_dedicated_linux.zip -d /output;

COPY ./dist/linux /output

FROM debian:trixie-slim

HEALTHCHECK NONE

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

ENV LANG=en_US.UTF-8 `
    LANGUAGE=en_US.UTF-8 `
    LC_ALL=en_US.UTF-8

RUN dpkg --add-architecture i386 &&`
    apt-get update &&`
    apt-get install -y `
        ca-certificates locales locales-all libsdl1.2debian whiptail libc6:i386 libstdc++6:i386 tmux `
        --no-install-recommends --no-install-suggests --no-upgrade &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* &&`
    useradd --home /app --gid root --system CS2D &&`
    mkdir --parents /app /dist/sys/logs &&`
    chown CS2D:root -R /app;

COPY --chown=CS2D:root --from=downloader /output /app

RUN chmod +x /app/cs2d_dedicated &&`
    chmod +x /app/ll-tests/gamesvr-cs2d.sh;

USER CS2D

WORKDIR /app

CMD ["/bin/bash"]

ONBUILD USER root
