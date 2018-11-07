#!/bin/bash

DATASPECTS_VERSION=181105a

echo "Extracting ontologies..."
docker run \
  --volume /home/lex/dataspectsStandardSystem:/usr/src \
  --volume /media/lex/LEXSAMSUNG-64GB/ProvisionDSAsDSCookbook:/usr/ProvisionDSAsDSCookbook \
  --workdir /usr/src/dataspects_lib \
  --network dataspectsstandardsystem_default \
  --rm \
    dataspects/dataspects:$DATASPECTS_VERSION \
      bundle exec bin/dataspects \
        --profiles /usr/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml \
          manage /usr/ProvisionDSAsDSCookbook/jobs/extract_dataspectsSystemCoreAndCookbookOntologies_from_mediawiki.rb
