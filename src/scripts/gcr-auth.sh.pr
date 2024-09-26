#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     platform=linux;;
    Darwin*)    platform=mac;;
    CYGWIN*)    platform=windows;;
    MINGW*)     platform=windows;;
    MSYS_NT*)   platform=windows;;
    *)          platform="UNKNOWN:${unameOut}"
esac

if [ "${platform}" != "windows" ] && ! command -v sudo > /dev/null 2>&1; then
  printf '%s\n' "sudo is required to configure Docker to use GCP repositories."
  printf '%s\n' "Please install it and try again."
  return 1
fi

# Set sudo to work whether logged in as root user or non-root user
if [[ $EUID == 0 ]] || [[ "${platform}" == "windows" ]]; then export SUDO=""; else export SUDO="sudo"; fi

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
