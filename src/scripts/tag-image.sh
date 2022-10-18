#!/bin/bash

SOURCE_TAG=$(eval echo "$EVAL_SOURCE_TAG")
TARGET_TAG=$(eval echo "$EVAL_TARGET_TAG")

IMAGE_ROOT="$PARAM_REGISTRY_URL/${!INDIRECT_PROJECT_ID}/$PARAM_IMAGE"
gcloud container images add-tag --quiet \
    "$IMAGE_ROOT:$SOURCE_TAG" \
    "$IMAGE_ROOT:$TARGET_TAG"