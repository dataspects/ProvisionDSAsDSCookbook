DATASPECTS_VERSION=181116d

docker run \
  --name dataspects_sidekiq \
  --network localmediawiki_default \
  --env REDIS_URL=redis://redis:6379/12 \
  --add-host="elasticsearch:172.22.0.5" \
  --rm \
  -it \
  --env DATASPECTS_SEARCH_CONFIG_FILE=/usr/dataspectsSoftware/ProvisionDSAsDSCookbook/config/dataspectsSearch_config.yml \
  --env DATASPECTS_PLUGINS_FOLDER=/usr/dataspectsSoftware/PLUGINS \
  --volume ${PWD}/..:/usr/dataspectsSoftware \
  --workdir /usr/dataspectsSoftware/dataspects_api \
    dataspects/dataspects:$DATASPECTS_VERSION \
      sidekiq -e development
