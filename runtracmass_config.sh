# CONFIG FILE FOR TRACMASS CONTAINER EXECUTION
# 
# This file contains the configuration for running the Tracmass container.
# It includes the image name, resource limits, volume mounts, and other settings.
#
# These likely need to be adjusted for your system and data.
# If you use more mounted files, use MNT_ prefix for the variable name.
#
# NOTE: mount variables MUST begin with MNT_
#       this naming convention is used to identify which variables are volume mounts

# Tracmass container image name
TM_IMAGE=docker.io/ezraeisbrenner/tracmass.org-e20fdaf-nemo-orca1

# Memory and CPU limits for the container
TM_MEM=10g
TM_CPU=2

# Set up paths for volume mounts

# output directory
MNT_OUT=$(pwd -P)/test/output

# input data directory
MNT_DATA=$(pwd -P)/test/orca1/fields

# namelist
# MNT_NML=$(pwd -P)/test/namelist.in

# seed file
# MNT_SEED=$(pwd -P)/test/seeds.txt

# topography files
MNT_TOPO1=$(pwd -P)/test/orca1/topo/mesh_hgr.nc
MNT_TOPO2=$(pwd -P)/test/orca1/topo/mesh_zgr.nc
MNT_TOPO3=$(pwd -P)/test/orca1/topo/bathy_level.nc

# For debugging purposes, set to true to disable entrypoint
# will run the container with /bin/bash\
# NOTE: namelist will not be adjusted for container use
# NOTE: further, compiler are not installed in the container
DISABLE_ENTRYPOINT=false
