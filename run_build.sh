#!/bin/bash

set -euo pipefail

docker build -t ipa_builder:latest ./ipa_builder

docker volume create dib_tmp
docker volume create dib_cache

run_the_build () {
    set -x

    local build_arch="${1:-amd64}"

    case "$build_arch" in
        "amd64"|"arm64")
            echo "building for $build_arch" ;;
        *)
            echo "unknown build arch" && exit 1 ;;
    esac
    

        local d_output_dir="/output"
    local image_name="ipa-debian12-2023.1-chi-${build_arch}"

    docker run \
        --rm \
        --privileged \
        --env "DIB_SHOW_IMAGE_USAGE=1" \
        --env "TMPDIR=/dib_tmp" \
        --env "DIB_IMAGE_CACHE=/dib_cache" \
        --env-file ipa_debian.env \
        -v "dib_cache:/dib_cache:rw" \
        -v "dib_tmp:/dib_tmp:rw" \
        -v "$(pwd)/output:${d_output_dir}:rw" \
        ipa_builder:latest \
            -x \
            --no-tmpfs \
            --checksum \
            --logfile "${d_output_dir}/${image_name}.log" \
            -o "${d_output_dir}/${image_name}" \
            -a "${build_arch}" \
            chi_ipa \
            debian-minimal

    set +x
}

run_the_build "$@"
