#!/bin/bash

IMAGE_ROOT="$PARAM_REGISTRY_URL/${!EVAL_PROJECT_ID}/$PARAM_IMAGE"
gcloud container images add-tag --quiet \
    "$IMAGE_ROOT:$PARAM_SOURCE_TAG" \
    "$IMAGE_ROOT:$PARAM_TARGET_TAG"