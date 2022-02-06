#!/bin/bash
#------------------------------------- pg_hba.conf -------------------------------------------
#host    dbname      all           0.0.0.0/0                      reject #lock_for_load_dbname
#local   dbname      all                                          reject #lock_for_load_dbname
#---------------------------------------------------------------------------------------------
CMD=$1
export PG_DATA_DIRECTORY=/var/lib/pgsql/{{ postgresql_version }}/data
if [[ ! -z "${CMD}" ]]; then
if [[ "${CMD}" != "START" && "${CMD}" != "STOP" ]]; then
echo "Need parameter: START or STOP !"
exit 2
fi
if [[ "${CMD}" == "START" ]]; then
sed -i "/.*dbname.*lock_for_load_dbname/s/^#\+//" ${PG_DATA_DIRECTORY}/pg_hba.conf
sleep 5
systemctl reload postgresql-{{ postgresql_version }}
sleep 2
# скорректировать
#SQLCMD="INSERT INTO public.log_kills (datname, procpid, sess_id, usename, application_name, client_addr, backend_start, xact_start, query_start, waiting, waiting_reason, current_query, rsgname, rsgqueueduration, ok, typekill, kill, killer) SELECT datname, procpid, sess_id, usename, application_name, client_addr, backend_start, xact_start, query_start, waiting, waiting_reason, current_query, rsgname, rsgqueueduration ,pg_terminate_backend(procpid) as ok ,'terminate' as typekill ,clock_timestamp() as kill ,session_user as killer FROM pg_catalog.pg_stat_activity WHERE datname='hrdata' AND usename is not null AND usename <> 'postgres' AND usename <> 'gpadmin' AND usename <> 'gpmon' AND procpid <> pg_backend_pid() AND usename not in ( '$(sed """s/ /','/g""" ${MASTER_DATA_DIRECTORY}/users.special)','$(sed """s/ /','/g""" ${MASTER_DATA_DIRECTORY}/users.nolock_for_hrdata)' );"
echo ${SQLCMD}
psql -p {{ postgresql_port }} -d pgedb -c "${SQLCMD}"
fi
if [[ "${CMD}" == "STOP" ]]; then
sed -i "/^[^#].*dbname.*lock_for_load_dbname/s/^/#/" ${PG_DATA_DIRECTORY}/pg_hba.conf
sleep 5
systemctl reload postgresql-{{ postgresql_version }}
sleep 5
fi
cat ${PG_DATA_DIRECTORY}/pg_hba.conf | grep -B5 -A5 dbname
exit 0
else
echo "Need parameter: START or STOP !"
exit 1
fi
