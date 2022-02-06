--- job Vacuum ----------------------------------------------------------------------------------------------------------------------------------------

DO $$
DECLARE
    jid integer := 0;
    scid integer;
BEGIN

-- Creating a new job
INSERT INTO pgagent.pga_job(
    jobjclid, jobname, jobdesc, jobhostagent, jobenabled
)
SELECT 1::integer as jobjclid, 'Vacuum'::text as jobname, 'sudo gpasswd --add pgagent postgres
chmod 750 /var/lib/pgsql или chmod 750 /part_1/pgsql
chmod 750 /var/lib/pgsql/vacuum.sh

cat /home/pgagent/VACUUM.log | grep ====='::text as jobdesc, ''::text as jobhostagent, true as jobenabled
WHERE NOT EXISTS (SELECT * FROM pgagent.pga_job WHERE jobname = 'Vacuum')
RETURNING jobid INTO jid;

-- Step 1
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
)
SELECT jid as jstjobid, '1 - check'::text as jstname, true as jstenabled, 's'::character(1) as jstkind,
    ''::text as jstconnstr, 'pgedb'::name as jstdbname, 'f'::character(1) as jstonerror,
    'DO $do$
DECLARE dts timestamptz;
DECLARE dtn timestamptz;
BEGIN
	SELECT pg_postmaster_start_time() INTO dts;
	SELECT now() INTO dtn;
	IF (dtn - dts) < interval ''5 minutes''
	THEN
		RAISE EXCEPTION ''PostgreSQL started just now. No need to do anything. Job stopped.'';
	END IF;
	COMMIT;
END $do$;
'::text as jstcode, ''::text as jstdesc
WHERE jid != 0;

-- Step 2
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
)
SELECT jid as jstjobid, '2 - Vacuum'::text as jstname, true as jstenabled, 'b'::character(1) as jstkind,
    ''::text as jstconnstr, ''::name as jstdbname, 'f'::character(1) as jstonerror,
    'cd /home/pgagent
PORT={{ postgresql_port }} /var/lib/pgsql/vacuum.sh'::text as jstcode, ''::text as jstdesc
WHERE jid != 0;

-- Schedules
-- Inserting a schedule
INSERT INTO pgagent.pga_schedule(
    jscjobid, jscname, jscdesc, jscenabled,
    jscstart,     jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
)
SELECT
    jid as jscjobid, 'everyday'::text as jscname, ''::text as jscdesc, true as jscenabled,
    '2019-07-09 01:00:00+03'::timestamp with time zone as jscstart, 
    -- Minutes
    ARRAY[true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscminutes,
    -- Hours
    ARRAY[false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jschours,
    -- Week days
    ARRAY[true,true,true,true,true,true,true]::boolean[] as jscweekdays,
    -- Month days
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays,
    -- Months
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays
WHERE jid != 0;

END
$$;

--- job Analyze ---------------------------------------------------------------------------------------------------------------------------------------

DO $$
DECLARE
    jid integer := 0;
    scid integer;
BEGIN

-- Creating a new job
INSERT INTO pgagent.pga_job(
    jobjclid, jobname, jobdesc, jobhostagent, jobenabled
)
SELECT 1::integer as jobjclid, 'Analyze'::text as jobname, 'sudo gpasswd --add pgagent postgres
chmod 750 /var/lib/pgsql или chmod 750 /part_1/pgsql
chmod 750 /var/lib/pgsql/analyze.sh

cat /home/pgagent/ANALYZE.log | grep ====='::text as jobdesc, ''::text as jobhostagent, true as jobenabled
WHERE NOT EXISTS (SELECT * FROM pgagent.pga_job WHERE jobname = 'Analyze')
RETURNING jobid INTO jid;

-- Step 1
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
)
SELECT jid as jstjobid, '1 - check'::text as jstname, true as jstenabled, 's'::character(1) as jstkind,
    ''::text as jstconnstr, 'pgedb'::name as jstdbname, 'f'::character(1) as jstonerror,
    'DO $do$
DECLARE dts timestamptz;
DECLARE dtn timestamptz;
BEGIN
	SELECT pg_postmaster_start_time() INTO dts;
	SELECT now() INTO dtn;
	IF (dtn - dts) < interval ''5 minutes''
	THEN
		RAISE EXCEPTION ''PostgreSQL started just now. No need to do anything. Job stopped.'';
	END IF;
	COMMIT;
END $do$;
'::text as jstcode, ''::text as jstdesc
WHERE jid != 0;

-- Step 2
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
)
SELECT jid as jstjobid, '2 - Analyze'::text as jstname, true as jstenabled, 'b'::character(1) as jstkind,
    ''::text as jstconnstr, ''::name as jstdbname, 'f'::character(1) as jstonerror,
    'cd /home/pgagent
PORT={{ postgresql_port }} /var/lib/pgsql/analyze.sh'::text as jstcode, ''::text as jstdesc
WHERE jid != 0;

-- Schedules
-- Inserting a schedule
INSERT INTO pgagent.pga_schedule(
    jscjobid, jscname, jscdesc, jscenabled,
    jscstart,     jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
)
SELECT
    jid as jscjobid, 'everyday'::text as jscname, ''::text as jscdesc, true as jscenabled,
    '2019-07-09 23:15:00+03'::timestamp with time zone as jscstart, 
    -- Minutes
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscminutes,
    -- Hours
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true]::boolean[] as jschours,
    -- Week days
    ARRAY[true,true,true,true,true,true,true]::boolean[] as jscweekdays,
    -- Month days
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays,
    -- Months
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays
WHERE jid != 0;

END
$$;

--- job kill idle in transaction-----------------------------------------------------------------------------------------------------------------------

DO $$
DECLARE
    jid integer := 0;
    scid integer;
BEGIN
-- Creating a new job
INSERT INTO pgagent.pga_job(
    jobjclid, jobname, jobdesc, jobhostagent, jobenabled
)
SELECT 1::integer as jobjclid, 'kill idle in transaction'::text as jobname, ''::text as jobdesc, ''::text as jobhostagent, true as jobenabled
WHERE NOT EXISTS (SELECT * FROM pgagent.pga_job WHERE jobname = 'kill idle in transaction')
RETURNING jobid INTO jid;

-- Steps
-- Inserting a step (jobid: NULL)
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
)
SELECT jid as jstjobid, 'kill'::text as jstname, true as jstenabled, 's'::character(1) as jstkind,
    ''::text as jstconnstr, 'pgedb'::name as jstdbname, 'f'::character(1) as jstonerror,
    'INSERT INTO public.log_kills(
	kill ,killer ,typekill ,ok
	,datid ,datname ,pid ,usesysid ,usename ,application_name ,client_addr ,client_hostname ,client_port
	,backend_start ,xact_start ,query_start ,state_change ,wait_event_type ,wait_event ,state ,backend_xid ,backend_xmin ,backend_type ,query)
SELECT clock_timestamp() as kill
	,session_user as killer 
	,''terminate'' as typekill
	,pg_terminate_backend(pid) as ok
	,datid ,datname ,pid ,usesysid ,usename ,application_name ,client_addr ,client_hostname ,client_port
	,backend_start ,xact_start ,query_start ,state_change ,wait_event_type ,wait_event ,state ,backend_xid ,backend_xmin ,backend_type ,query
FROM pg_catalog.pg_stat_activity 
WHERE state in (''idle in transaction'', ''idle in transaction (aborted)'') 
AND current_timestamp - state_change > interval ''30 minutes'' 
AND backend_type = ''client backend'' -- м.б. это подойдёт
AND pid <> pg_backend_pid();
'::text as jstcode, ''::text as jstdesc
WHERE jid != 0;

-- Schedules
-- Inserting a schedule
INSERT INTO pgagent.pga_schedule(
    jscjobid, jscname, jscdesc, jscenabled,
    jscstart,     jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
)
SELECT
    jid as jscjobid, 'every 15 min'::text as jscname, ''::text as jscdesc, true as jscenabled,
    '2019-07-09 23:15:00+03'::timestamp with time zone as jscstart, 
    -- Minutes
	ARRAY[false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscminutes,
    -- Hours
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jschours,
    -- Week days
    ARRAY[false,false,false,false,false,false,false]::boolean[] as jscweekdays,
    -- Month days
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays,
    -- Months
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false]::boolean[] as jscmonthdays
WHERE jid != 0;

END
$$;

--- job pg log switch ---------------------------------------------------------------------------------------------------------------------------------

DO $$
DECLARE
    jid integer;
    scid integer;
BEGIN
-- Creating a new job
INSERT INTO pgagent.pga_job(
    jobjclid, jobname, jobdesc, jobhostagent, jobenabled
) VALUES (
    1::integer, 'pg log switch'::text, ''::text, ''::text, true
) RETURNING jobid INTO jid;

-- Steps
-- Inserting a step (jobid: NULL)
INSERT INTO pgagent.pga_jobstep (
    jstjobid, jstname, jstenabled, jstkind,
    jstconnstr, jstdbname, jstonerror,
    jstcode, jstdesc
) VALUES (
    jid, 'log_switch'::text, true, 's'::character(1),
    ''::text, 'pgedb'::name, 'f'::character(1),
    'SELECT public.log_switch();'::text, ''::text
) ;

-- Schedules
-- Inserting a schedule
INSERT INTO pgagent.pga_schedule(
    jscjobid, jscname, jscdesc, jscenabled,
    jscstart,     jscminutes, jschours, jscweekdays, jscmonthdays, jscmonths
) VALUES (
    jid, 'every hour'::text, ''::text, true,
    '2021-09-18 03:57:14+00'::timestamp with time zone, 
    -- Minutes
    ARRAY[true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[],
    -- Hours
    ARRAY[true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true]::boolean[],
    -- Week days
    ARRAY[true,true,true,true,true,true,true]::boolean[],
    -- Month days
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]::boolean[],
    -- Months
    ARRAY[false,false,false,false,false,false,false,false,false,false,false,false]::boolean[]
) RETURNING jscid INTO scid;
END
$$;

-------------------------------------------------------------------------------------------------------------------------------------------------------
