#!/bin/bash -e

if which podman &> /dev/null; then
    CONTAINER_CMD="podman"
    CONTAINER_CHECK_FILE="/run/.containerenv"
elif which docker &> /dev/null; then
    CONTAINER_CMD="docker"
    CONTAINER_CHECK_FILE="/.dockerenv"
fi

if [ -n "$CONTAINER_CHECK_FILE" ] && [ ! -f "$CONTAINER_CHECK_FILE" ]; then
    $CONTAINER_CMD run --rm --volume "$(pwd):/code" -w /code docker.io/zephyrprojectrtos/ci /code/container-build.sh
    exit
fi

[ ! -d .west ] && west init -l zephyr-led-button && west update
west build --board teensy40 --build-dir build-container zephyr-led-button
