#!/bin/bash
PATH=/usr/local/bin/:$PATH

FTP_HOST=ftp.example.com
FTP_USER=ftpuser
FTP_PWD=password

APP_NAME=file-service-storage

cd /data/bravoer/music-crm

FILENAME="`date +%Y%m%d-%H%M%S`_${APP_NAME}.tar.gz"
tar -zcf ${FILENAME} storage

curl -T ${FILENAME} ftp://${FTP_HOST}/database-backups/${APP_NAME}/${FILENAME} --user ${FTP_USER}:${FTP_PWD}

echo "$(date) Cleaning file storage backups. Only keep 4 most recent backups."
for i in `curl -s -l ftp://${FTP_HOST}/database-backups/${APP_NAME}/ --user ${FTP_USER}:${FTP_PWD} | grep tar.gz | head -n -4`; do
  echo "Deleting /database-backups/${APP_NAME}/${i}"
  curl ftp://${FTP_HOST}/database-backups/${APP_NAME}/${i} --user ${FTP_USER}:${FTP_PWD} -O --quote "DELE /database-backups/${APP_NAME}/${i}"
done

rm ${FILENAME}

exit 0
