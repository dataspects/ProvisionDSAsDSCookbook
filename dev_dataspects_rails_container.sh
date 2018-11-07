DATASPECTS_VERSION=181105a

docker run \
  --name dataspects_rails \
  --network dataspectsstandardsystem_default \
  --publish 3000:3000 \
  --env SIDEKIQ_UI_USERNAME=none \
  --env SIDEKIQ_UI_PASSWORD=none \
  --env API_KEY=none \
  --env REDIS_URL=redis://redis:6379/12 \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/src/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/src \
  --volume ${PWD}:/usr/src \
  --workdir /usr/src/dataspects_api \
  --rm \
  -it \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rails server -e development