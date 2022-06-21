#!/bin/bash

EMAILS="support@lab.local"
#EMAILCC="me@lab.local"
#EMAILBCC="me@lab.local;support@lab.local"

LOG_FILE='/var/lib/pgsql/AutoShutdownPG.log'
DiskUsageLimit=95

pgIsActive=$(systemctl is-active patroni)
percentUsed1=$(df -h | grep "/dev/mapper/cl-root" | awk {'print $5'} | sed s/%//g)
percentUsed2=$(df -h | grep "/dev/mapper/postgresql_wal_vg-pg_wal" | awk {'print $5'} | sed s/%//g)
percentUsed3=$(df -h | grep "/dev/mapper/postgresql_data_vg-pg_data" | awk {'print $5'} | sed s/%//g)

if [[ "${pgIsActive}" = "active" ]]
then
if [[ ${percentUsed1} -ge ${DiskUsageLimit} ]]
then
systemctl stop patroni 2>&1 | ts '[\%Y-\%m-\%d \%H:\%M:\%S]' &>>${LOG_FILE}
MSG="patroni was shutdown<BR>log file ${LOG_FILE}"
echo -e "${MSG}" | mutt \
        -e 'set content_type = text/html' \
        -e 'set from = "alerts@lab.local"' \
        -s "ALERT: Free Space Ended on $(hostname)" ${EMAIL} -c ${EMAILCC} -b ${EMAILBCC}
elif [[ ${percentUsed2} -ge ${DiskUsageLimit} ]]
then
systemctl stop patroni 2>&1 | ts '[\%Y-\%m-\%d \%H:\%M:\%S]' &>>${LOG_FILE}
MSG="patroni was shutdown<BR>log file ${LOG_FILE}"
echo -e "${MSG}" | mutt \
        -e 'set content_type = text/html' \
        -e 'set from = "alerts@lab.local"' \
        -s "ALERT: Free Space Ended on $(hostname)" ${EMAIL} -c ${EMAILCC} -b ${EMAILBCC}
elif [[ ${percentUsed3} -ge ${DiskUsageLimit} ]]
then
systemctl stop patroni 2>&1 | ts '[\%Y-\%m-\%d \%H:\%M:\%S]' &>>${LOG_FILE}
MSG="patroni was shutdown<BR>log file ${LOG_FILE}"
echo -e "${MSG}" | mutt \
        -e 'set content_type = text/html' \
        -e 'set from = "alerts@lab.local"' \
        -s "ALERT: Free Space Ended on $(hostname)" ${EMAIL} -c ${EMAILCC} -b ${EMAILBCC}
else
   echo "free space is ok"
fi
else
   echo "patroni is shut already"
fi
