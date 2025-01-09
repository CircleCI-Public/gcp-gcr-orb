#!/usr/bin/env bash

ORB_VAL_REGISTRY_URL="$(circleci env subst "$ORB_VAL_REGISTRY_URL")"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     platform=linux;;
    Darwin*)    platform=mac;;
    CYGWIN*)    platform=windows;;
    MINGW*)     platform=windows;;
    MSYS_NT*)   platform=windows;;
    *)          platform="UNKNOWN:${unameOut}"
esac

# Set sudo to work whether logged in as root user or non-root user
if [[ $EUID == 0 ]] || [[ "${platform}" == "windows" ]]; then
    export SUDO=""
else
    export SUDO="sudo"
fi

# configure Docker to use gcloud as a credential helper
mkdir -p "$HOME/.docker"

if [[ "$ORB_VAL_REGISTRY_URL" == *"docker.pkg.dev" ]]; then
    gcloud auth configure-docker --quiet --project "${!ORB_ENV_PROJECT_ID}" "$ORB_VAL_REGISTRY_URL"
else
    gcloud auth configure-docker --quiet --project "${!ORB_ENV_PROJECT_ID}"
fi

# if applicable, provide user access to the docker config file
if [[ -d "$HOME/.docker" ]]; then
    $SUDO chown "$USER:$USER" "$HOME/.docker" -R
fi
if [[ -d "$HOME/.config" ]]; then
    $SUDO chown "$USER:$USER" "$HOME/.config" -R
fi
