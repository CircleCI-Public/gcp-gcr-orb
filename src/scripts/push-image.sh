#!/bin/bash 

ORB_VAL_REGISTRY_URL="$(circleci env subst "$ORB_VAL_REGISTRY_URL")"
ORB_VAL_IMAGE="$(circleci env subst "$ORB_VAL_IMAGE")"
ORB_VAL_DIGEST_PATH="$(circleci env subst "$ORB_VAL_DIGEST_PATH")"

IFS="," read -ra DOCKER_TAGS <<< "$ORB_EVAL_TAG"
PROJECT_ID="${!ORB_ENV_PROJECT_ID}"

for tag_to_eval in "${DOCKER_TAGS[@]}"; do
    TAG=$(eval echo "$tag_to_eval")
    set -x
    docker push "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_IMAGE:$TAG"
    set +x
done

if [ -n "$ORB_VAL_DIGEST_PATH" ]; then
    mkdir -p "$(dirname "$ORB_VAL_DIGEST_PATH")"
    SAMPLE_FIRST=$(eval echo "${DOCKER_TAGS[0]}")
    set -x
    docker image inspect --format="{{index .RepoDigests 0}}" "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_IMAGE:$SAMPLE_FIRST" > "$ORB_VAL_DIGEST_PATH"
    set +x
fi
