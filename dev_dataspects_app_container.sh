DATASPECTS_VERSION=181105a

docker run \
  --name dataspects_app \
  --network dataspectsstandardsystem_default \
  --volume ${PWD}:/usr/src \
  --workdir /usr/src/dataspects_lib \
  --rm \
  -it \
    dataspects/dataspects:$DATASPECTS_VERSION \
      /bin/bash
