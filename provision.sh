#!/bin/bash

ANSIBLETAGS=(
  place_run_containers_manually_scripts
  place_system_profiles
  inject_dataspectsSystemCoreAndCookbookOntology
  # extract_dataspectsSystemCoreOntology
  execute_mediawiki_maintenance_runJobs
  # reset_elasticsearch_index
  place_dataspects_search_config_files
)

time ansible-playbook \
  --extra-vars \
    "dataspectsSystem_path_on_host=/home/lex/dataspectsStandardSystem \
     dataspects_version=181105a" \
  --tags $(IFS=, eval 'echo "${ANSIBLETAGS[*]}"') \
    ansible_playbooks/place_run_containers_manually_scripts.yml \
    ansible_playbooks/place_system_profiles.yml \
    ansible_playbooks/inject_dataspectsSystemCoreOntology_into_mediawiki.yml \
    ansible_playbooks/reset_elasticsearch_index.yml \
    ansible_playbooks/place_dataspects_search_config_files.yml \
    ansible_playbooks/execute_mediawiki_maintenance_runJobs.yml \
    # ansible_playbooks/index_dataspectsStandardSystem.yml \
    # ansible_playbooks/index_dataspectsSystemSoftware.yml
