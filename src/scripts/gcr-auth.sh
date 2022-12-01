#!/bin/bash 

# Set sudo to work whether logged in as root user or non-root user
if [[ $EUID == 0 ]]; then export SUDO=""; else export SUDO="sudo"; fi


# Check if the AWS CLI is installed
if ! command -v gcloud &>/dev/null; then
  echo "GCP CLI could not be found. Please install it before initiating the GCP CLI.
  
Use the circleci/gcp-cli orb to install the GCP CLI.
https://circleci.com/developer/orbs/orb/circleci/gcp-gcr#usage-examples

Job example:

jobs:
    build_app:
        executor: gcp-gcr/default
        steps:
            - checkout

            - gcp-cli/setup

            - gcp-gcr/gcr-auth


Workflow example:

workflows:
    test_and_deploy:
        jobs:
        - gcp-gcr/add-image-tag:
            pre-steps:
                - gcp-cli/setup
"
  exit 1
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
