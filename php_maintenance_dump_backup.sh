#!/bin/bash
TIMESTAMP=`date +%Y%m%d%H%M%S`
echo "maintenance/dumpBackup.php..."
docker exec \
  -it \
  --workdir /var/www/html/w/maintenance \
    localmediawiki_mediawikiservice_1 \
      bash -c "php dumpBackup.php --full > /var/www/html/w/${TIMESTAMP}_dump.xml"

sudo mv /var/lib/docker/volumes/localmediawiki_mediawiki_root/_data/${TIMESTAMP}_dump.xml \
    /home/lex/BACKUP/Cookbook/
