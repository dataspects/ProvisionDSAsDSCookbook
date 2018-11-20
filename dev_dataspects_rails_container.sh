DATASPECTS_VERSION=181116d

docker run \
  --name dataspects_rails \
  --network localmediawiki_default \
  --publish 3000:3000 \
  --env SIDEKIQ_UI_USERNAME=none \
  --env SIDEKIQ_UI_PASSWORD=none \
  --env API_KEY=none \
  --env REDIS_URL=redis://redis:6379/12 \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/ProvisionDSAsDSCookbook/config/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/ProvisionDSAsDSCookbook \
  --volume ${PWD}:/usr/ProvisionDSAsDSCookbook \
  --workdir /usr/ProvisionDSAsDSCookbook/dataspects_api \
  --rm \
  -it \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rails server -e development
