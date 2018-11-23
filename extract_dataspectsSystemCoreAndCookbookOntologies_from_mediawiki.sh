#!/bin/bash

DATASPECTS_VERSION=181116d

echo "Extracting ontologies..."
docker run \
  --name dataspects_extract \
  --network localmediawiki_default \
  --rm \
  -it \
  --volume ${PWD}/..:/usr/dataspectsSoftware \
  --workdir /usr/dataspectsSoftware/dataspects_lib \
  --env SHOW_DATASPECTS_LOG=true \
    dataspects/dataspects:$DATASPECTS_VERSION \
      bundle exec bin/dataspects \
        --profiles /usr/dataspectsSoftware/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml \
          manage /usr/dataspectsSoftware/ProvisionDSAsDSCookbook/jobs/extract_dataspectsSystemCoreAndCookbookOntologies_from_mediawiki.rb
