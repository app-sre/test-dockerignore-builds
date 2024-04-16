#!/bin/bash

IMAGE_NAME="quay.io/app-sre/test-dockerignore-builds"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

GIT_STATUS=$(git status -su)
if [[ -n "$GIT_STATUS" ]]; then
    echo "Non empty git status [$GIT_STATUS]"
    exit 1
fi

docker build -t "${IMAGE_NAME}:latest" .
docker tag "${IMAGE_NAME}:latest" "${IMAGE_NAME}:${IMAGE_TAG}"

DOCKER_CONF="${PWD}/.docker"
mkdir -p "${DOCKER_CONF}"
docker --config="${DOCKER_CONF}" login -u="${QUAY_USER}" -p="${QUAY_TOKEN}" quay.io

docker --config="${DOCKER_CONF}" push "${IMAGE_NAME}:latest"
docker --config="${DOCKER_CONF}" push "${IMAGE_NAME}:${IMAGE_TAG}"
