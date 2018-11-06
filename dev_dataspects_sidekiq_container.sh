DATASPECTS_VERSION=181105a

docker run \
  --name dataspects_sidekiq \
  --network dataspectsstandardsystem_default \
  --env REDIS_URL=redis://redis:6379/12 \
  --rm \
  -it \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/src/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/src \
  --volume ${PWD}:/usr/src \
  --workdir /usr/src/dataspects_api \
    dataspects/dataspects:$DATASPECTS_VERSION \
      sidekiq -e development
