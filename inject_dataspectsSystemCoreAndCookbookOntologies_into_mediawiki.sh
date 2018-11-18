#!/bin/bash

DATASPECTS_VERSION="181116d"
DATASPECTS_SYSTEM_INSTANCE_NAME="myDataspectsStandardSystem181116a"
DATASPECTS_SYSTEM_INSTANCE_PATH="/home/lex/myDataspectsStandardSystem181116a"

# echo "Resetting Elasticsearch Index..."
# docker run \
#   --network dataspectsstandardsystem_default \
#   --volume ${PWD}:/usr/src \
#   --workdir /tmp/dataspects_lib \
#   --rm \
#     dataspects/dataspects:$DATASPECTS_VERSION \
#       bundle exec bin/dataspects \
#         --profile /usr/src/config/standard_system_profiles.yml \
#           manage /usr/src/jobs/reset_elasticsearch_index.rb

#echo "Cloning repositories..."
#git clone git@github.com:dataspects/dataspectsSystemCoreOntology.git
#git clone git@github.com:dataspects/dataspectsSystemCookbookOntology.git

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
        --profile /usr/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml \
          manage /usr/ProvisionDSAsDSCookbook/jobs/inject_dataspectsSystemCoreAndCookbookOntologies_into_mediawiki.rb

# docker exec \
#   dataspectsstandardsystem_php-fpm_1 bash \
#     -c "php w/maintenance/runJobs.php \
#         && php w/extensions/SemanticMediaWiki/maintenance/rebuildData.php"
