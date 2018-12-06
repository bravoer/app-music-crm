#!/bin/bash
PATH=/usr/local/bin/:$PATH

FTP_HOST=ftp.example.com
FTP_USER=ftpuser
FTP_PWD=password

BACKUP_DIR_SERVICE_NAME=virtuoso
DAYS=30

docker=`which docker`
if [ $? -ne 0 ]; then
    echo "ERROR: could not find docker executable";
    exit -1;
fi

# Backup Virtuoso
virtuoso_container=`docker ps --filter "label=com.docker.compose.project=app-music-crm" --filter "label=com.docker.compose.service=database" --format "{{.Names}}"`
date=`date +%y%m%dT%H%M`
backup_name="virtuoso_backup_$date-"

$docker exec -i $virtuoso_container mkdir -p backups
$docker exec -i $virtuoso_container isql-v <<EOF
    exec('checkpoint');
		backup_context_clear();
		backup_online('$backup_name',30000,0,vector('backups'));
		exit;
EOF
$docker exec -i $virtuoso_container /bin/bash -c "find /data/backups/ -name 'virtuoso_backup_*' -mtime +$DAYS -print0 | xargs -0 rm 2> /dev/null"

# FTP upload
cd /data/bravoer/app-music-crm/scripts

archive_name="$backup_name-all.tar.gz"
tar -zcf ${archive_name} ../database/backups/${backup_name}*.bp
curl -T ${archive_name} ftp://${FTP_HOST}/database-backups/${BACKUP_DIR_SERVICE_NAME}/${archive_name} --user ${FTP_USER}:${FTP_PWD}

rm ${archive_name}

exit 0

