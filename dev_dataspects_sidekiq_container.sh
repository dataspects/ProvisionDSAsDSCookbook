DATASPECTS_VERSION=181116d

docker run \
  --name dataspects_sidekiq \
  --network localmediawiki_default \
  --env REDIS_URL=redis://redis:6379/12 \
  --rm \
  -it \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/ProvisionDSAsDSCookbook/config/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/ProvisionDSAsDSCookbook \
  --volume ${PWD}:/usr/ProvisionDSAsDSCookbook \
  --workdir /usr/ProvisionDSAsDSCookbook/dataspects_api \
    dataspects/dataspects:$DATASPECTS_VERSION \
      sidekiq -e development
