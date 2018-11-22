DATASPECTS_VERSION=181116d

# We have to find elasticsearch's IP by "docker inspect elasticsearch" first...

docker run \
  --name dataspects_rails \
  --network localmediawiki_default \
  --publish 3000:3000 \
  --env SIDEKIQ_UI_USERNAME=none \
  --env SIDEKIQ_UI_PASSWORD=none \
  --env API_KEY=none \
  --env REDIS_URL=redis://redis:6379/12 \
  --add-host="elasticsearch:172.22.0.2" \
  --rm \
  -it \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/dataspectsSoftware/ProvisionDSAsDSCookbook/config/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/dataspectsSoftware/PLUGINS \
  --volume ${PWD}/..:/usr/dataspectsSoftware \
  --workdir /usr/dataspectsSoftware/dataspects_api \
    dataspects/dataspects:$DATASPECTS_VERSION \
      rails server -e development
