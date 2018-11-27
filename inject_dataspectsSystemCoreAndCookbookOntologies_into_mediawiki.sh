#!/bin/bash

# #echo "Cloning repositories..."
# #git clone git@github.com:dataspects/dataspectsSystemCoreOntology.git
# #git clone git@github.com:dataspects/dataspectsSystemCookbookOntology.git

./php_maintenance_dump_backup.sh

# echo "Nuke content"
# echo "Template"
# docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 10 --all"
# echo "Form"
# docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 106 --all"
# echo "Property"
# docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 102 --all"
# echo "Concept"
# docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 108 --all"
# echo "Category"
# docker exec localmediawiki_mediawikiservice_1 bash -c "php w/maintenance/nukeNS.php --delete --ns 14 --all"

echo "Injecting ontologies..."
SHOW_DATASPECTS_LOG=true \
dataspects \
  --profiles config/standard_system_profiles.yml \
  manage ./jobs/inject_dataspectsSystemCoreAndCookbookOntologies_into_mediawiki.rb

echo "Run jobs and rebuild data"
docker exec \
  localmediawiki_mediawikiservice_1 bash \
    -c "php w/maintenance/rebuildall.php \
        php w/maintenance/runJobs.php \
        && php w/extensions/SemanticMediaWiki/maintenance/rebuildData.php \
        && php w/maintenance/runJobs.php"

echo "Resetting Elasticsearch Index..."
# GEM
SHOW_DATASPECTS_LOG=true \
dataspects \
  --profiles config/standard_system_profiles.yml \
  manage ./jobs/reset_elasticsearch_index.rb

# DEV
# BUNDLE_GEMFILE="dataspects/Gemfile" \
# bundle exec dataspects/bin/dataspects

echo "Indexing..."
SHOW_DATASPECTS_LOG=true \
dataspects \
  --profiles config/standard_system_profiles.yml \
  manage ./jobs/index_dataspectsSystemCookbookWiki.rb
