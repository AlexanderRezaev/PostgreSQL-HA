#!/bin/bash
# Можно включать/выключать бэкапирование WAL не рестартуя PostgreSQL сервер.
# archive_command = '/bin/bash /var/lib/pgsql/{?}/data/archive_wal.sh %p %f'
# ARCHIVE=0 не спасает, если есть именованный replication_slots, например, barman
# sudo -iu postgres psql -p 5432 postgres -c "SELECT * FROM pg_replication_slots;"
# sudo -iu postgres psql -p 5432 postgres -c "SELECT pg_drop_replication_slot('barman');"
# sudo -iu postgres PGPORT 5432 psql -p ${PGPORT} postgres -c "DO \$do\$ BEGIN IF EXISTS (SELECT FROM pg_replication_slots where slot_name='barman') THEN PERFORM pg_drop_replication_slot('barman'); END IF; END \$do\$;"
#chown postgres:postgres archive_wal.sh
#chmod 700 archive_wal.sh

# MANAGEMENT
DEBUG=0
LOG=0
ARCHIVE=0

# SETTINGS
PGSERVER=$(hostname)                            # или кластер name, в случае кластера
PDATA='/var/lib/postgresql/data'
LOG_FILE='/tmp/archive_wal-5432.log'
LOG_DBG_FILE='/tmp/archive_wal-5432-debug.log'
#BRSERVER='172.27.172.99'                       # если стандартный barman
BRSERVER=''                                     # если barman cloud s3
S3BUCKET='backups'

if [[ ${DEBUG} -eq 1 ]]; then
echo "$(date +'[%Y-%m-%d %H:%M:%S]')" >> ${LOG_DBG_FILE}
set -x
exec 2>>${LOG_DBG_FILE}
fi

if [[ ${LOG} -eq 1 ]] && [[ BRSERVER -eq '' ]]; then   # barman cloud s3
echo "$(date +'[%Y-%m-%d %H:%M:%S]') ^ $1 ^ $2 ^ ${AWS_PROFILE_MINIO} ^ ${MINIO_ENDPOINT_URL}" >> ${LOG_FILE}
fi
if [[ ${LOG} -eq 1 ]] && [[ BRSERVER -ne '' ]]; then
echo "$(date +'[%Y-%m-%d %H:%M:%S]') ^ $1 ^ $2" >> ${LOG_FILE}
fi

if [[ ${ARCHIVE} -eq 1 ]] && [[ BRSERVER -eq '' ]];    # barman cloud s3
then
barman-cloud-wal-archive -P ${AWS_PROFILE_MINIO} -j --endpoint-url ${MINIO_ENDPOINT_URL} s3://${S3BUCKET} ${PGSERVER} ${PDATA}/${1}
RC=$?
elif [[ ${ARCHIVE} -eq 1 ]] && [[ BRSERVER -ne '' ]];
then
cd ${PDATA} && rsync -a $1 barman@${BRSERVER}:/var/lib/barman/${PGSERVER}/incoming/$2
RC=$?
else
RC=0
fi

exit ${RC}
