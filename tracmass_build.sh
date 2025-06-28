#!/bin/bash

TRACMASS_REPOSITORY="https://github.com/TRACMASS/Tracmass.git"
TRACMASS_REVISION="e20fdaf"
PROJECT="NEMO"
CASE="ORCA1"

DOCKER_USER="ezraeisbrenner"

earthly \
    --build-arg TRACMASS_REPOSITORY=${TRACMASS_REPOSITORY} \
    --build-arg TRACMASS_REVISION=${TRACMASS_REVISION} \
    --build-arg PROJECT=${PROJECT} \
    --build-arg CASE=${CASE} \
    --build-arg DOCKER_USER=${DOCKER_USER} \
    +oci-run
