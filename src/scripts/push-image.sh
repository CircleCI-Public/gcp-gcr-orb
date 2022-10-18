#!/bin/bash 

IFS="," read -ra DOCKER_TAGS <<< "$PARAM_TAG"

for tag in "${DOCKER_TAGS[@]}"; do
    docker push "$PARAM_REGISTRY_URL/${!EVAL_PROJECT_ID}/$PARAM_IMAGE:${tag}"
done

if [ -n "$PARAM_DIGEST_PATH" ]; then
    mkdir -p "$(dirname "$PARAM_DIGEST_PATH")"
    docker image inspect --format="{{index .RepoDigests 0}}" "$PARAM_REGISTRY_URL/${!EVAL_PROJECT_ID}/$PARAM_IMAGE:${DOCKER_TAGS[0]}" > "$PARAM_DIGEST_PATH"
fi
