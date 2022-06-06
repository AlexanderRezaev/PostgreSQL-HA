#!/bin/bash
# export DiskUsageLimit=90 && /home/hadoop/DiskUsage.sh >/dev/null

EMAILS="support@lab.local"
#EMAILCC="me@lab.local"
#EMAILBCC="me@lab.local;support@lab.local"
Host=$(hostname)
Message=""
for line in $(df -h | tail --lines=+2 | grep -vE 'abc:/xyz/pqr|tmpfs|cdrom|Used' | sed s/%//g | awk '{ print$6"-"$5"-"$4; }')
do
  percent=$(echo "$line" | awk -F - '{print$2}' | cut -d % -f 1)
  partition=$(echo "$line" | awk -F - '{print$1}')
  available=$(echo "$line" | awk -F - '{print$3}')
  if [ $percent -ge ${DiskUsageLimit} ]
  then
    Message="$Message<BR>${percent}% used on disk ${partition}, available ${available}"
  fi

done

# send an email
if [ -n "$Message" ];
then
  Message="${Host}${Message}"
  echo -e "${Message}" | mutt \
    -e 'set content_type = text/html' \
    -e 'set from = "alerts@lab.local"' \
    -s "Disk Usage Problem on $Host" $EMAILS -c $EMAILCC -b $EMAILBCC

# MAILSMTP='smtp.mail.ru:465'
#  echo -e "${Message}" | mutt -d3 -e "set content_type=text/html" -e "set send_charset=utf-8" -e "set allow_8bit=yes" -e "set use_ipv6=no" \
#    -e "set move=no" -e "set copy=no" \
#    -e "set from=\"${MAILLOGIN}\"" -e "set realname=\"${MAILFROM}\"" \
#    -e "set smtp_authenticators=\"login\"" -e "set smtp_url=smtps://\"${MAILLOGIN}\"@\"${MAILSMTP}\"" -e "set smtp_pass=\"${MAILPWD}\"" \
#    -e "set ssl_starttls=yes" -e "set ssl_force_tls=yes" -e "set ssl_verify_dates=no" -e "set ssl_verify_host=no" \
#    -s "Disk Usage Problem on $Host" ${EMAILS} 2>&1
fi
