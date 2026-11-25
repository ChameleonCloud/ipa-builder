#!/bin/bash

set -euo pipefail

docker build -t ipa_builder:latest ./ipa_builder

docker volume create dib_tmp
docker volume create dib_cache

run_the_build () {
    set -x

    local build_arch="${1:-amd64}"
    local release="${2:-2026.1}"

    case "$build_arch" in
        "amd64"|"arm64")
            echo "building for $build_arch" ;;
        *)
            echo "unknown build arch" && exit 1 ;;
    esac

    if [ ! -f "ipa_${release}.env" ]; then
        echo "unknown release ${release}" && exit 1
    fi
    

        local d_output_dir="/output"
    local image_name="ipa-debian12-${release}-chi-${build_arch}"

    docker run \
        --rm \
        --privileged \
        --env "DIB_SHOW_IMAGE_USAGE=1" \
        --env DIB_QUIET \
        --env "TMPDIR=/dib_tmp" \
        --env "DIB_IMAGE_CACHE=/dib_cache" \
        --env-file ipa_debian.env \
        --env-file "ipa_${release}.env" \
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
