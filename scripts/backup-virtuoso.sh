#!/bin/bash
PATH=/usr/local/bin/:$PATH

FTP_HOST=ftp.example.com
FTP_USER=ftpuser
FTP_PWD=password

APP_NAME=virtuoso

cd /data/bravoer/music-crm/scripts

FILENAME="`date +%Y%m%d-%H%M%S`_${APP_NAME}.ttl"

curl -g --data-urlencode query@backup.sparql http://$(docker inspect --format='{{ .NetworkSettings.Networks.bridge.IPAddress }}' musiccrm_db_1):8890/sparql > ${FILENAME}

tar -zcf ${FILENAME}.tar.gz ${FILENAME} 
curl -T ${FILENAME}.tar.gz ftp://${FTP_HOST}/database-backups/${APP_NAME}/${FILENAME}.tar.gz --user ${FTP_USER}:${FTP_PWD}

rm ${FILENAME}*

exit 0

