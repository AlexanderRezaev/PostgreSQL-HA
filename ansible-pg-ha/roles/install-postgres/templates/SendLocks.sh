#!/bin/bash
# https://wiki.postgresql.org/wiki/Lock_Monitoring

EMAILS="support@lab.local"
#EMAILCC="me@lab.local"
#EMAILBCC="me@lab.local;support@lab.local"

CNT=$(psql -p {{ postgresql_port }} -tq -c " \
        SELECT count(*) \
                FROM pg_catalog.pg_locks bl \
                        JOIN pg_catalog.pg_stat_activity a \
                                ON bl.pid = a.pid \
                        JOIN pg_catalog.pg_locks kl \
                                ON bl.locktype = kl.locktype \
                                and bl.database is not distinct from kl.database \
                                and bl.relation is not distinct from kl.relation \
                                and bl.page is not distinct from kl.page \
                                and bl.tuple is not distinct from kl.tuple \
                                and bl.transactionid is not distinct from kl.transactionid \
                                and bl.classid is not distinct from kl.classid \
                                and bl.objid is not distinct from kl.objid \
                                and bl.objsubid is not distinct from kl.objsubid \
                                and bl.pid <> kl.pid \
                        JOIN pg_catalog.pg_stat_activity ka \
                                ON kl.pid = ka.pid \
                WHERE kl.granted and not bl.granted \
        ;" 2>/dev/null)

MSG=$(psql -p {{ postgresql_port }} -Htq -c " \
WITH cte as ( \
                SELECT 'database'::text as \"database\", 'blocking_AGE'::text as \"blocking_AGE\", 'blocking_pid'::text as blocking_pid, 'blocking_user(Who)'::text as blocking_user, 'blocking_query_start'::text as blocking_query_start, 'blocking_mode'::text as blocking_mode, 'blocking_relation'::text as blocking_relation, 'blocked_AGE'::text as \"blocked_AGE\", 'blocked_pid'::text as blocked_pid, 'blocked_user'::text as blocked_user, 'blocked_query_start'::text as blocked_query_start, 'blocked_mode'::text as blocked_mode, 'blocked_relation'::text as blocked_relation, 'blocking_query'::text as blocking_query, 'blocked_query'::text as blocked_query, 1::text as ord \
        UNION  \
                SELECT \
                        ka.datname::text as database, \
                        to_char(age(now(), ka.query_start),'HH24h:MIm:SSs')::text as "blocking_AGE", \
                        kl.pid::text as blocking_pid, \
                        ka.usename::text as "blocking_user", \
                        ka.query_start::text as blocking_query_start, \
                        string_agg(kl.mode, ', ' order by kl.mode)::text as "blocking_mode", \
                        kl.relation::text as "blocking_relation", \
                        to_char(age(now(), a.query_start),'HH24h:MIm:SSs')::text as "blocked_AGE", \
                        bl.pid::text as blocked_pid, \
                        a.usename::text as blocked_user, \
                        a.query_start::text as blocked_query_start, \
                        bl.mode::text as "blocked_mode", \
                        bl.relation::text as "blocked_relation", \
                        ka.query::text as blocking_query, \
                        a.query::text as blocked_query, \
                        2::text as ord \
                FROM pg_catalog.pg_locks bl \
                        JOIN pg_catalog.pg_stat_activity a \
                                ON bl.pid = a.pid \
                        JOIN pg_catalog.pg_locks kl \
                                ON bl.locktype = kl.locktype \
                                and bl.database is not distinct from kl.database \
                                and bl.relation is not distinct from kl.relation \
                                and bl.page is not distinct from kl.page \
                                and bl.tuple is not distinct from kl.tuple \
                                and bl.transactionid is not distinct from kl.transactionid \
                                and bl.classid is not distinct from kl.classid \
                                and bl.objid is not distinct from kl.objid \
                                and bl.objsubid is not distinct from kl.objsubid \
                                and bl.pid <> kl.pid \
                        JOIN pg_catalog.pg_stat_activity ka \
                                ON kl.pid = ka.pid \
                WHERE kl.granted and not bl.granted \
                GROUP BY ka.datname, a.query_start, kl.pid, ka.usename, ka.query_start, kl.relation, bl.pid, a.usename, a.query_start, bl.mode, bl.relation, ka.query, a.query \
        ) \
        SELECT \"database\", \"blocking_AGE\", \"blocking_pid\", \"blocking_user\", \"blocking_query_start\", \"blocking_mode\", \"blocking_relation\", \"blocked_AGE\", \"blocked_pid\", \"blocked_user\", \"blocked_query_start\", \"blocked_mode\", \"blocked_relation\", \"blocking_query\", \"blocked_query\" FROM cte ORDER BY ord, blocked_query_start, blocking_query_start, blocking_pid, blocked_pid, blocking_mode \
        ;" 2>/dev/null | sed 's/<table border="1">/<table border="1" style="font-family:consolas;font-size:8px">/');

if [[ "${CNT}" -ne "0" ]]
then
        echo -e "${MSG}" | mutt \
                -e 'set content_type = text/html' \
                -e 'set from = "alerts@lab.local"' \
                -s "ALERT: Locks on $(hostname)" ${EMAIL} -c ${EMAILCC} -b ${EMAILBCC}
#else
#       echo "nothing"
fi
