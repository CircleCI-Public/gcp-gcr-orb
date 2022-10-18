#!/bin/bash 

IFS="," read -ra DOCKER_TAGS <<< "$EVAL_TAG"
PROJECT_ID="${!INDIRECT_PROJECT_ID}"

set -x
for tag_to_eval in "${DOCKER_TAGS[@]}"; do
    TAG=$(eval "$tag_to_eval")
    docker push "$PARAM_REGISTRY_URL/$PROJECT_ID/$PARAM_IMAGE:$TAG"
done

if [ -n "$PARAM_DIGEST_PATH" ]; then
    mkdir -p "$(dirname "$PARAM_DIGEST_PATH")"
    docker image inspect --format="{{index .RepoDigests 0}}" "$PARAM_REGISTRY_URL/$PROJECT_ID/$PARAM_IMAGE:${DOCKER_TAGS[0]}" > "$PARAM_DIGEST_PATH"
fi
