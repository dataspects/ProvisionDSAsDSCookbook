#!/bin/bash

# [[IsTestScriptFor::dataspectsApp]]

DATASPECTS_VERSION=181113a

docker run \
  --network mydataspectsstandardsystem181112a_default \
  --volume /media/lex/LEXSAMSUNG-64GB/dataspects_docker_image_factory:/usr/dataspects_docker_image_factory \
  --volume ${PWD}:/usr/workspace \
  --rm \
  --tty \
  --env SHOW_DATASPECTS_LOG=false \
  --env PROFILES=/usr/workspace/config/standard_system_profiles.yml \
  --workdir /usr/dataspects_docker_image_factory/dataspects_lib \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rspec spec/extract_from_MW_and_inject_into_MW_spec.rb

# alias watchgitstatus="watch --color 'pwd; git -c color.status=always status'"
