#!/bin/bash

# Source the configuration file
source ./config.sh

# =========================================================================
# Below code is automatic and does not need user interference
# =========================================================================

# Initialize an associative array for volume mounts
declare -A VOLUMES

# Automatically populate the VOLUMES array
for VAR in $(compgen -A variable | grep '^MNT_'); do
    VALUE=${!VAR}
    if [[ -n "$VALUE" ]]; then
        if [[ "$VAR" == "MNT_OUT" ]]; then
            VOLUMES["$VALUE"]="/output"
        elif [[ "$VAR" == "MNT_DATA" ]]; then
            VOLUMES["$VALUE"]="/input/data"
        else
            VOLUMES["$VALUE"]="/input/$(basename $VALUE)"
        fi
    fi
done

# Create output directories if they do not exist
mkdir -p $TM_OUT

# Start building the CMD variable
CMD="run -it"

# Loop through the array and add non-empty mounts to CMD
for SRC in "${!VOLUMES[@]}"; do
    CMD="$CMD -v $SRC:${VOLUMES[$SRC]}"
done

# Add resource limits
CMD="$CMD --cpus=$TM_CPU"
CMD="$CMD --memory=$TM_MEM"

# Disable entrypoint
if [ "$DISABLE_ENTRYPOINT" = true ]; then
    CMD="$CMD --entrypoint /bin/bash"
fi

# Print the constructed command
echo "================================================================="
echo "Constructing command to run the container..."
echo "================================================================="
echo " "
echo "[docker/podman] $CMD"
echo " "
echo "================================================================="
read -p "Do you want to proceed? (yes/no): " response
response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
if [[ "$response" == "yes" || "$response" == "y" ]]; then
    echo "Proceeding..."
elif [[ "$response" == "no" || "$response" == "n" ]]; then
    echo "Aborting..."
    exit 0
else
    echo "Invalid response. Please enter 'yes', 'no', 'y', or 'n'."
    exit 1
fi

# Execute the appropriate container runtime
if [ "$1" == "docker" ]; then
    echo "Using Docker..."
    docker $CMD --user $(id -u):$(id -g) $TM_IMAGE
else
    echo "Using Podman..."
    podman $CMD $TM_IMAGE
fi
