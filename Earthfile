# earthly version
VERSION 0.6
# image to set up variables
FROM docker.io/library/bash

ARG TRACMASS_REPOSITORY="https://github.com/TRACMASS/Tracmass.git"
ARG TRACMASS_REVISION="e20fdaf"
ARG PROJECT="NEMO"
ARG CASE="ORCA1"

ARG DOCKER_USER="ezraeisbrenner"

ARG SOURCE_NAME=$(echo "$(bash -c '
  SOURCE_REPO="${TRACMASS_REPOSITORY}"
  if [[ "$SOURCE_REPO" =~ github\.com[:/]([^/]+)/([^/]+)\.git$ ]] || [[ "$SOURCE_REPO" =~ github\.com[:/]([^/]+)/([^/]+)$ ]]; then
    USERNAME="${BASH_REMATCH[1]}"
    REPONAME="${BASH_REMATCH[2]}"
    SOURCE_NAME="${USERNAME}-${REPONAME}"
    SOURCE_NAME=$(echo "$SOURCE_NAME" | sed "s/[^a-zA-Z0-9]/-/g" | sed "s/--*/-/g" | sed "s/^-\|-$//g")
  else
    REPO_NAME=$(basename "$SOURCE_REPO" .git)
    SOURCE_NAME=$(echo "$REPO_NAME" | sed "s/[^a-zA-Z0-9]/-/g" | sed "s/--*/-/g" | sed "s/^-\|-$//g")
  fi
  echo "$SOURCE_NAME"
')")
ARG FILESTEM=$(echo "$(bash -c '
  SOURCE_NAME="${SOURCE_NAME}"
  REVISION="${TRACMASS_REVISION//[^a-zA-Z0-9_.]/}"
  echo "${SOURCE_NAME}-${REVISION}-${PROJECT}-${CASE}"
')")
ARG IMAGE_NAME=$(echo "$(bash -c 'echo "docker.io/${DOCKER_USER,,}/${FILESTEM,,}"')")

runtime:
    FROM docker.io/library/ubuntu:20.04
    ENV DEBIAN_FRONTEND noninteractive
    RUN apt-get update \
        && apt-get install -yq --no-install-recommends \
        locales \
        ca-certificates \
        libnetcdf-dev \
        libnetcdff-dev \
        && apt-get clean && rm -rf /var/lib/apt/lists/*
    RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
        locale-gen
    ENV SHELL=/bin/bash \
        LC_ALL=en_US.UTF-8 \
        LANG=en_US.UTF-8 \
        LANGUAGE=en_US.UTF-8

buildenv:
    FROM +runtime
    RUN apt-get update \
        && apt-get install -yq --no-install-recommends \
        git \
        make \
        build-essential \
        gcc \
        gfortran \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

compile:
    FROM +buildenv
    RUN git clone ${TRACMASS_REPOSITORY} /tracmass && \
        if [ ${TRACMASS_REVISION} != latest ]; \
        then cd /tracmass && git checkout ${TRACMASS_REVISION}; \
        fi
    RUN if [ -z $CASE ]; then CASE=${PROJECT}; fi && sed -i \
        -e "s/^\s*PROJECT\s*=.*/PROJECT="${PROJECT}"/g" \
        -e "s/^\s*CASE\s*=.*/CASE="${CASE}"/g" \
        -e "s/^\s*ARCH\s*=.*/ARCH=/g" \
        -e "s/^\s*NETCDFLIBS\s*=.*/NETCDFLIBS=automatic-44/g" /tracmass/Makefile
    RUN cd /tracmass && \
        make --file=Makefile

    SAVE ARTIFACT /tracmass/runtracmass
    SAVE ARTIFACT /tracmass/namelist.in

image:
    FROM +runtime
    COPY +compile/runtracmass /tracmass/runtracmass
    COPY +compile/namelist.in /tracmass/namelist.in
    RUN printf "%s\n" \
        "#!/bin/bash" \
        "set -e" \
        "if [ -f /input/namelist.in ]; then" \
        "    cp /input/namelist.in /tracmass/namelist.in" \
        "fi" \
        "sed -i -e 's/^\s*outDataDir\s*=.*/outDataDir=\"\/output\/\"/g' /tracmass/namelist.in" \
        "sed -i -e 's/^\s*seeddir\s*=.*/seeddir=\"\/input\/\"/g' /tracmass/namelist.in" \
        "sed -i -e 's/^\s*topoDataDir\s*=.*/topoDataDir=\"\/input\/\"/g' /tracmass/namelist.in" \
        "sed -i -e 's/^\s*physDataDir\s*=.*/physDataDir=\"\/input\/data\/\"/g' /tracmass/namelist.in" \
        "cp /tracmass/namelist.in /output/namelist.out" \
        "cd /tracmass" \
        "./runtracmass" \
        > /entrypoint.sh
    RUN chmod +x /entrypoint.sh
    ENTRYPOINT ["/entrypoint.sh"]

    SAVE IMAGE $IMAGE_NAME

all:
    BUILD +image