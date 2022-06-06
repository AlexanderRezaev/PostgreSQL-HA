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
# MAILSMTP='smtp.mail.ru:465'
#  echo -e "${MSG}" | mutt -d3 -e "set content_type=text/html" -e "set send_charset=utf-8" -e "set allow_8bit=yes" -e "set use_ipv6=no" \
#    -e "set move=no" -e "set copy=no" \
#    -e "set from=\"${MAILLOGIN}\"" -e "set realname=\"${MAILFROM}\"" \
#    -e "set smtp_authenticators=\"login\"" -e "set smtp_url=smtps://\"${MAILLOGIN}\"@\"${MAILSMTP}\"" -e "set smtp_pass=\"${MAILPWD}\"" \
#    -e "set ssl_starttls=yes" -e "set ssl_force_tls=yes" -e "set ssl_verify_dates=no" -e "set ssl_verify_host=no" \
#    -s "ALERT: Free Space Ended on $(hostname)" ${EMAIL} 2>&1
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
