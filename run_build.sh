#!/bin/bash

set -euo pipefail

docker build -t ipa_builder:latest ./ipa_builder

docker volume create ipa_cache

image_name="ipa-debian12-2023.1"

docker run --rm \
    --privileged \
    --env-file ipa_debian.env \
    -v ipa_cache:/cache:rw \
    -v "$(pwd)/output":/output:rw \
    ipa_builder:latest \
        -o "/output/${image_name}" \
        chi_ipa \
        debian-minimal
