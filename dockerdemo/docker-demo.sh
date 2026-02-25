#!/usr/bin/env bash

set -euo pipefail

IMAGE_NAME="mynginx_image1"
CONTAINER_NAME="mynginx3"

usage() {
  echo "Usage: $0 {build|run|stop|rm}"
  echo
  echo "  build  Build the image (${IMAGE_NAME}) from the local dockerfile"
  echo "  run    Run the container (${CONTAINER_NAME}) on port 80"
  echo "  stop   Stop the running container"
  echo "  rm     Remove the container"
}

cmd="${1:-}"

case "${cmd}" in
  build)
    docker build -t "${IMAGE_NAME}" .
    ;;
  run)
    docker run --name "${CONTAINER_NAME}" -p 80:80 -d "${IMAGE_NAME}"
    ;;
  stop)
    docker stop "${CONTAINER_NAME}" || true
    ;;
  rm)
    docker rm "${CONTAINER_NAME}" || true
    ;;
  *)
    usage
    exit 1
    ;;
esac

