#!/bin/bash
port=${PORT}
logfile='VACUUM.log'

pgstate=($(psql -p "${port}" -d postgres -c "select pg_is_in_recovery()::text;" -At | tr -d '\r'));
if [[ "${pgstate}" = "true" ]]
then
exit -1
fi

IFS="|"
echo "===== $(date '+%Y-%m-%d %H:%M:%S') VACUUM started on port ${port} ====="  > ${logfile} 2>&1
cmd1="SELECT datname FROM pg_database WHERE datistemplate = false;"
DBs=($(psql -p "${port}" -d postgres -c "${cmd1}" -XAt | tr -s '\n' '|' | tr -d '\r'));
for dbName in ${!DBs[*]}; do
cmd5="SELECT '"'"'===== '"'"' || to_char(now() , '"'"'YYYY-MM-DD\"T\"HH24:MI:SSOF'"'"') || '"'"':00'"'"' || '"'"' ===== '"'"' || current_database() || '"'"' ===== '"'"' || ARRAY(SELECT x.extname FROM pg_extension x JOIN pg_namespace n ON n.oid = x.extnamespace ORDER BY x.extname)::text || '"'"' ====='"'"';"; \
psql -U postgres -d ${DBs[$dbName]} -c "${cmd5}" -XAt >> ${logfile} 2>&1; \
cmd2="select table_schema from information_schema.tables where table_schema not in ('pg_catalog','information_schema') group by 1;";
Ss=($(psql -p ${port} -d ${DBs[$dbName]} -c "${cmd2}" -XAt | tr -s '\n' '|' | tr -d '\r'));
for sName in ${!Ss[*]}; do
cmd3="select ist.table_name from information_schema.tables as ist left outer join ( SELECT nmsp_parent.nspname::text AS parent_schema, parent.relname::text AS parent  FROM pg_inherits JOIN pg_class parent ON pg_inherits.inhparent = parent.oid JOIN pg_namespace nmsp_parent ON nmsp_parent.oid = parent.relnamespace GROUP BY 1,2 ) pt on pt.parent_schema = ist.table_schema and pt.parent = ist.table_name where ist.table_schema = '"'"'${Ss[$sName]}'"'"' and pt.parent is null and ist.table_type not ilike '"'"'VIEW%'"'"' and ist.table_type not ilike '"'"'FOREIGN%'"'"' and ist.table_schema not in ('"'"'pg_catalog'"'"','"'"'information_schema'"'"') group by 1 order by 1;"; \
Ts=($(psql -p ${port} -d ${DBs[$dbName]} -c "${cmd3}" -XAt | tr -s '\n' '|' | tr -d '\r'));
for tName in ${!Ts[*]}; do
schemaName=$(echo ${Ss[$sName]} | sed 's/"/""/g')
tableName=$(echo ${Ts[$tName]} | sed 's/"/""/g')
echo "  $(date '+%Y-%m-%d %H:%M:%S') : VACUUM VERBOSE \"${schemaName}\".\"${tableName}\";" >> ${logfile} 2>&1
psql -p ${port} -d ${DBs[$dbName]} -c "VACUUM VERBOSE \"${schemaName}\".\"${tableName}\";" >> ${logfile} 2>&1
done;
done;
done;
echo "===== $(date '+%Y-%m-%d %H:%M:%S') VACUUM finished on port ${port} =====" >> ${logfile} 2>&1
exit 0
