#!/bin/bash

DATASPECTS_VERSION=181105a

docker run \
  --volume /home/lex/dataspectsStandardSystem:/usr/src \
  --volume /media/lex/LEXSAMSUNG-64GB/ProvisionDSAsDSCookbook:/usr/ProvisionDSAsDSCookbook \
  --workdir /usr/src/dataspects_lib \
  --network dataspectsstandardsystem_default \
  --env PROFILES=/usr/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml \
  --rm \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rspec spec/extract_from_MW_and_inject_into_MW_spec.rb
