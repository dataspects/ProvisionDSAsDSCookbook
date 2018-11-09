#!/bin/bash

DATASPECTS_VERSION=181109b

docker run \
  --volume /media/lex/LEXSAMSUNG-64GB/dataspects_docker_image_factory:/usr/dataspects_docker_image_factory \
  --volume /media/lex/LEXSAMSUNG-64GB/ProvisionDSAsDSCookbook:/usr/ProvisionDSAsDSCookbook \
  --workdir /usr/dataspects_docker_image_factory/dataspects_lib \
  --network dataspectsstandardsystem_default \
  --env PROFILES=/usr/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml \
  --env SHOW_DATASPECTS_LOG=false \
  --rm \
  --tty \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rspec spec/extract_from_MW_and_inject_into_MW_spec.rb
