#!/bin/bash

DATASPECTS_VERSION="181116d"
DATASPECTS_SYSTEM_INSTANCE_NAME="localmediawiki"
DATASPECTS_SYSTEM_INSTANCE_PATH="/home/lex/localmediawiki"
SYSTEM_PROFILES="/usr/dataspectsSoftware/ProvisionDSAsDSCookbook/config/standard_system_profiles.yml"
JOBS="/usr/dataspectsSoftware/ProvisionDSAsDSCookbook/jobs"

# #echo "Cloning repositories..."
# #git clone git@github.com:dataspects/dataspectsSystemCoreOntology.git
# #git clone git@github.com:dataspects/dataspectsSystemCookbookOntology.git

./php_maintenance_dump_backup.sh

echo "Nuke content"
# echo "Main"
# docke exe localmediawiki_mediawikiservice_1 bas -c "php w/maintenance/nukeNS.php --delete --ns 0 --all"
echo "Template"
docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 10 --all"
echo "Form"
docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 106 --all"
echo "Property"
docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 102 --all"
echo "Concept"
docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 108 --all"
echo "Category"
docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 14 --all"

echo "Injecting ontologies..."
docker run \
  --volume ${DATASPECTS_SYSTEM_INSTANCE_PATH}:/usr/src \
  --volume ${PWD}/..:/usr/dataspectsSoftware \
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
    -c "php w/maintenance/rebuildall.php \
        php w/maintenance/runJobs.php \
        && php w/extensions/SemanticMediaWiki/maintenance/rebuildData.php \
        && php w/maintenance/runJobs.php"

echo "Resetting Elasticsearch Index..."
docker run \
  --volume ${DATASPECTS_SYSTEM_INSTANCE_PATH}:/usr/src \
  --volume ${PWD}/..:/usr/dataspectsSoftware \
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
  --volume ${PWD}/..:/usr/dataspectsSoftware \
  --workdir /tmp/dataspects_lib \
  --network ${DATASPECTS_SYSTEM_INSTANCE_NAME,,}_default \
  --env SHOW_DATASPECTS_LOG=true \
  --rm \
    dataspects/dataspects:$DATASPECTS_VERSION \
      bundle exec bin/dataspects \
        --profile $SYSTEM_PROFILES \
          manage $JOBS/index_dataspectsSystemCookbookWiki.rb
