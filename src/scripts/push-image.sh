#!/bin/bash 

IFS="," read -ra DOCKER_TAGS <<< "$EVAL_TAG"
PROJECT_ID="${!INDIRECT_PROJECT_ID}"

for tag_to_eval in "${DOCKER_TAGS[@]}"; do
    TAG=$(eval echo "$tag_to_eval")
    docker push "$PARAM_REGISTRY_URL/$PROJECT_ID/$PARAM_IMAGE:$TAG"
done

if [ -n "$PARAM_DIGEST_PATH" ]; then
    mkdir -p "$(dirname "$PARAM_DIGEST_PATH")"
    SAMPLE_FIRST=$(eval echo "${DOCKER_TAGS[0]}")
    docker image inspect --format="{{index .RepoDigests 0}}" "$PARAM_REGISTRY_URL/$PROJECT_ID/$PARAM_IMAGE:$SAMPLE_FIRST" > "$PARAM_DIGEST_PATH"
fi
