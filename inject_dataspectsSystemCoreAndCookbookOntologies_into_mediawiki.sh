#!/bin/bash

DATASPECTS_VERSION="181116d"
DATASPECTS_SYSTEM_INSTANCE_NAME="localmediawiki"
DATASPECTS_SYSTEM_INSTANCE_PATH="/home/lex/localmediawiki"
SYSTEM_PROFILES="/usr/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml"
JOBS="/usr/ProvisionDSAsDSCookbook/jobs"

# #echo "Cloning repositories..."
# #git clone git@github.com:dataspects/dataspectsSystemCoreOntology.git
# #git clone git@github.com:dataspects/dataspectsSystemCookbookOntology.git
#
echo "Injecting ontologies..."
docker run \
  --volume ${DATASPECTS_SYSTEM_INSTANCE_PATH}:/usr/src \
  --volume ${PWD}:/usr/ProvisionDSAsDSCookbook \
  --workdir /tmp/dataspects_lib \
  --network ${DATASPECTS_SYSTEM_INSTANCE_NAME,,}_default \
  --rm \
  --env SHOW_DATASPECTS_LOG=true \
    dataspects/dataspects:${DATASPECTS_VERSION} \
      bundle exec bin/dataspects \
        --profile $SYSTEM_PROFILES \
          manage $JOBS/inject_dataspectsSystemCoreAndCookbookOntologies_into_mediawiki.rb

echo "Run jobs and rebuild data"
docker exec \
  localmediawiki_mediawikiservice_1 bash \
    -c "php w/maintenance/runJobs.php \
        && php w/extensions/SemanticMediaWiki/maintenance/rebuildData.php"

echo "Resetting Elasticsearch Index..."
docker run \
  --volume ${DATASPECTS_SYSTEM_INSTANCE_PATH}:/usr/src \
  --volume ${PWD}:/usr/ProvisionDSAsDSCookbook \
  --workdir /tmp/dataspects_lib \
  --network ${DATASPECTS_SYSTEM_INSTANCE_NAME,,}_default \
  --env SHOW_DATASPECTS_LOG=true \
  --rm \
    dataspects/dataspects:$DATASPECTS_VERSION \
      bundle exec bin/dataspects \
        --profile $SYSTEM_PROFILES \
          manage $JOBS/reset_elasticsearch_index.rb

echo "Indexing..."
docker run \
  --volume ${DATASPECTS_SYSTEM_INSTANCE_PATH}:/usr/src \
  --volume ${PWD}:/usr/ProvisionDSAsDSCookbook \
  --workdir /tmp/dataspects_lib \
  --network ${DATASPECTS_SYSTEM_INSTANCE_NAME,,}_default \
  --env SHOW_DATASPECTS_LOG=true \
  --rm \
    dataspects/dataspects:$DATASPECTS_VERSION \
      bundle exec bin/dataspects \
        --profile $SYSTEM_PROFILES \
          manage $JOBS/index_dataspectsSystemCookbookWiki.rb
