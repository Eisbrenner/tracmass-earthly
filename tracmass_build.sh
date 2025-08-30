#!/bin/bash

TRACMASS_REPOSITORY="https://github.com/TRACMASS/Tracmass.git"
TRACMASS_REVISION="e20fdaf"
PROJECT="NEMO"
CASE="ORCA1"

# optional: a seed file needs to be mounted after build
SEEDS_FILENAME="seeds.txt"

# optional: a namelist file to be used instead of the default one,
#           if provided also requires mounting after build
NAMELIST_FILENAME="namelist.in"

DOCKER_USER="ezraeisbrenner"

earthly \
    --build-arg TRACMASS_REPOSITORY=${TRACMASS_REPOSITORY} \
    --build-arg TRACMASS_REVISION=${TRACMASS_REVISION} \
    --build-arg PROJECT=${PROJECT} \
    --build-arg CASE=${CASE} \
    --build-arg NAMELIST_FILENAME=${NAMELIST_FILENAME} \
    --build-arg SEEDS_FILENAME=${SEEDS_FILENAME} \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    +all
