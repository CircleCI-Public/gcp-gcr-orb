#!/bin/bash 

# Set sudo to work whether logged in as root user or non-root user
if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi

# configure Docker to use gcloud as a credential helper
mkdir -p "$HOME/.docker"

if [[ "$PARAM_REGISTRY_URL" == *"docker.pkg.dev" ]]; then
    gcloud auth configure-docker --quiet --project "${!INDIRECT_PROJECT_ID}" "$PARAM_REGISTRY_URL"
else
    gcloud auth configure-docker --quiet --project "${!INDIRECT_PROJECT_ID}"
fi

# if applicable, provide user access to the docker config file
if [[ -d "$HOME/.docker" ]]; then
    $SUDO chown "$USER:$USER" "$HOME/.docker" -R
fi
if [[ -d "$HOME/.config" ]]; then
    $SUDO chown "$USER:$USER" "$HOME/.config" -R
fi
